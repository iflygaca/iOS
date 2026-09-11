# Backend Integration Guide: Express 5 + Node.js + PostgreSQL

**Scope:** Express 5 API, Cloud Run deployment, PostgreSQL (me-central2), HttpOnly JWT auth  
**Branch:** `claude/llm-wiki-categorization-wmdgta`  
**Target:** Complete within Q4 2026 and Q1 2027

---

## Current Stack

```
server/
├── src/
│   ├── index.ts              # Express app entry
│   ├── middleware/           # Auth, error handling, logging
│   ├── routes/               # API endpoints (/api/chat, /api/quiz, etc.)
│   ├── services/             # Business logic (auth, billing, chat)
│   ├── store.ts              # PostgreSQL queries (raw SQL today)
│   ├── brain/                # Captain Adel RAG orchestration
│   └── types/                # TypeScript interfaces
├── migrations/               # Forward-only PostgreSQL migrations
└── tests/                    # Vitest + supertest

Key dependencies:
- Express 5.x
- Node.js 20+
- PostgreSQL 15+
- jsonwebtoken (HttpOnly JWT)
- bcryptjs (password hashing)
- Zod (request validation)
- Postgres (pg driver, no ORM yet)
```

**Deployment Target:** Google Cloud Run (me-central2, Dammam region only)

---

## Immediate Priorities (Q4 2026)

### 1. Security Hardening (Repos #33, #34, #24)

**Current:** Basic auth, no rate limiting, missing security headers  
**Target:** Helmet, express-rate-limit, reviewed JWT strategy

#### 1a. Security Headers (helmet)

```bash
npm install helmet

# in server/src/index.ts
import helmet from 'helmet'

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'nonce-{random}"],
      styleSrc: ["'self'", 'https://fonts.googleapis.com'],
      imgSrc: ["'self'", 'data:', 'https:'],
      frameSrc: ["'none'"], // prevent clickjacking
      connectSrc: ["'self'", 'https://api.gemini.google.com'], // Gemini only
    },
  },
  hsts: {
    maxAge: 31536000, // 1 year
    includeSubDomains: true,
    preload: true,
  },
  referrerPolicy: { policy: 'strict-origin-when-cross-origin' },
  xContentTypeOptions: { noSniff: true },
  xFrameOptions: { action: 'deny' },
  xXssProtection: false, // modern browsers use CSP
}))
```

**Headers deployed:**
- `Strict-Transport-Security` (HSTS): Force HTTPS
- `X-Content-Type-Options: nosniff`: Prevent MIME sniffing
- `X-Frame-Options: DENY`: Prevent framing (clickjacking)
- `Content-Security-Policy`: Restrict script origins (no external CDNs except Gemini API)
- `Referrer-Policy`: Limit referrer leakage

#### 1b. Rate Limiting (express-rate-limit)

```bash
npm install express-rate-limit

// in middleware/rateLimiter.ts
import rateLimit from 'express-rate-limit'

// Brute-force protection on auth endpoints
export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // max 10 failed attempts per IP
  message: 'Too many login attempts. Please try again later.',
  skipSuccessfulRequests: true, // don't count successful login
  keyGenerator: (req) => req.ip || req.connection.remoteAddress,
})

// Global API rate limit (more lenient)
export const apiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100, // 100 req/min per IP
  skip: (req) => req.user?.role === 'admin', // admins unlimited
})

// Deploy:
app.post('/auth/login', authLimiter, loginHandler)
app.use('/api/', apiLimiter)
```

#### 1c. JWT Token Audit

```typescript
// Current: tokens in localStorage (VULNERABLE)
// Target: HttpOnly cookies only

// in middleware/auth.ts
export const setAuthToken = (res: Response, token: string) => {
  res.cookie('auth_token', token, {
    httpOnly: true,        // JS cannot read (XSS protection)
    secure: true,          // HTTPS only
    sameSite: 'strict',    // CSRF protection
    maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    path: '/',
  })
}

export const getAuthToken = (req: Request): string | null => {
  return req.cookies.auth_token || null
}

export const clearAuthToken = (res: Response) => {
  res.clearCookie('auth_token')
}
```

**Integration Steps:**
1. Install helmet and express-rate-limit
2. Apply middleware globally (helmet first)
3. Deploy auth-rate-limiter to `/auth/*` routes
4. Audit JWT token placement (move from localStorage to HttpOnly cookies)
5. Test CORS headers (verify learner app can still call API)
6. Run security-headers audit with OWASP ZAP

**Estimated Effort:** 1 week

**Deliverables:**
- ✅ Helmet CSP policy deployed
- ✅ Rate limiting on auth endpoints (10/15min per IP)
- ✅ Auth tokens moved to HttpOnly cookies
- ✅ HSTS header enforced

---

### 2. Request Validation (Repo #20: Zod)

**Current:** Minimal validation, no type safety on request bodies  
**Target:** Zod schemas for all API endpoints

```bash
npm install zod

# in server/src/types/schemas.ts
import { z } from 'zod'

// Quiz endpoint schemas
export const submitQuizAnswerSchema = z.object({
  quizId: z.string().uuid(),
  answers: z.array(z.object({
    questionId: z.string().uuid(),
    selectedOptionId: z.string().uuid(),
  })),
  timeSpent: z.number().min(0), // seconds
})

export const updateLearnerSettingsSchema = z.object({
  dailyStudyGoal: z.number().min(15).max(480),
  preferredLanguage: z.enum(['en', 'ar']),
  modules: z.array(z.string().min(2).max(4)), // e.g., ['elpt', 'aip']
  timezone: z.string().regex(/^[A-Za-z]+\/[A-Za-z_]+$/), // e.g., 'Asia/Riyadh'
})

// in server/src/routes/quiz.ts
import { submitQuizAnswerSchema } from '../types/schemas'

app.post('/api/quiz/submit', authenticate, async (req, res) => {
  try {
    const parsed = submitQuizAnswerSchema.parse(req.body)
    // Proceed with type-safe `parsed` object
    const result = await quizService.submitAnswers(req.user.id, parsed)
    res.json(result)
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ 
        error: 'Invalid request',
        details: error.errors 
      })
    }
    res.status(500).json({ error: 'Internal server error' })
  }
})
```

**Where to apply:**
- POST `/auth/register` (email, password, language)
- POST `/auth/login` (email, password)
- PATCH `/me/settings` (study goals, language, timezone)
- POST `/api/quiz/submit` (quiz answers, time spent)
- POST `/api/chat` (query to Captain Adel)
- PATCH `/api/admin/learner/:id` (instructor edits learner data)

**Integration Steps:**
1. Create `src/types/schemas.ts` with Zod definitions
2. Add validation middleware factory
3. Apply to 3-5 high-risk endpoints (auth, payments, learner data)
4. Test error responses (400 with detailed validation errors)
5. Export schemas for frontend (Zod type inference)

**Estimated Effort:** 1 week

---

### 3. ORM Migration: Prisma (Repo #26) or Drizzle (Repo #27)

**Current:** Raw SQL queries in `store.ts` (manual parameterization)  
**Target:** Type-safe ORM with auto-generated types

#### 3a. Prisma Setup

```bash
npm install @prisma/client
npm install -D prisma

# Initialize Prisma
npx prisma init

# Configure DATABASE_URL in .env (Cloud SQL connection string)
# DATABASE_URL="postgresql://user:pass@cloudsql-proxy:5432/flygaca"
```

#### 3b. Schema Definition

```prisma
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model Learner {
  id        String    @id @default(cuid())
  email     String    @unique
  name      String
  language  String    @default("en") // en or ar
  timezone  String    @default("Asia/Riyadh")
  
  quizzes   Quiz[]
  progress  LearnerProgress[]
  
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Quiz {
  id        String   @id @default(cuid())
  moduleId  String   // e.g., 'elpt', 'aip'
  learnerId String
  learner   Learner  @relation(fields: [learnerId], references: [id], onDelete: Cascade)
  
  answers   QuizAnswer[]
  score     Int?
  timeSpent Int? // seconds
  
  createdAt DateTime @default(now())
}

model QuizAnswer {
  id         String   @id @default(cuid())
  quizId     String
  quiz       Quiz     @relation(fields: [quizId], references: [id], onDelete: Cascade)
  
  questionId String
  selectedId String? // selected option ID (null = unanswered)
  isCorrect  Boolean?
  
  createdAt  DateTime @default(now())
  
  @@index([quizId])
}

model LearnerProgress {
  id        String   @id @default(cuid())
  learnerId String
  learner   Learner  @relation(fields: [learnerId], references: [id], onDelete: Cascade)
  
  moduleId  String   // 'elpt', 'aip'
  srsBag    Int      @default(0) // SRS box (0-5)
  streakDays Int     @default(0)
  
  updatedAt DateTime @updatedAt
  
  @@unique([learnerId, moduleId]) // one row per learner+module
}
```

#### 3c. Migration Workflow

```bash
# After schema change:
npx prisma migrate dev --name add_learner_progress

# This:
# 1. Creates SQL migration in prisma/migrations/
# 2. Applies to dev database
# 3. Regenerates @prisma/client types

# In production (Cloud Run):
# npx prisma migrate deploy (runs all pending migrations)
```

#### 3d. Usage in Routes

```typescript
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

// Type-safe queries with IDE autocomplete
app.get('/api/learner/:id/progress', authenticate, async (req, res) => {
  const progress = await prisma.learnerProgress.findUnique({
    where: {
      learnerId_moduleId: {
        learnerId: req.params.id,
        moduleId: req.query.moduleId as string,
      },
    },
  })
  
  res.json(progress)
})

// Batch update (e.g., daily streaks)
await prisma.learnerProgress.updateMany({
  where: { updatedAt: { lt: new Date(Date.now() - 24*60*60*1000) } },
  data: { streakDays: 0 },
})
```

**Integration Steps:**
1. Install Prisma CLI and client
2. Define schema for existing tables
3. Generate initial migration from current schema
4. Test migrations locally (dev database)
5. Create forward-only migration for each schema change
6. Deploy to production with CI/CD gate

**Estimated Effort:** 2-3 weeks (phased by feature)

---

### 4. Connection Pooling (PgBouncer or node-postgres)

**Current:** Direct PostgreSQL connections (no pooling)  
**Target:** PgBouncer or built-in pg pool (scalability for Cloud Run)

```typescript
// in server/src/db.ts
import { Pool } from 'pg'

export const pool = new Pool({
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  
  // Connection pool config
  max: 20,              // max connections
  idleTimeoutMillis: 30000, // close idle after 30s
  connectionTimeoutMillis: 2000, // fail fast if can't connect
})

// Monitor pool
pool.on('error', (err) => console.error('Unexpected error on idle client', err))
```

---

## Medium-Term Upgrades (Q1 2027)

### 5. Event Streaming (Kafka + node-rdkafka, Repo #47)

**Use case:** Learner interaction telemetry, flight-hour log ingestion

```bash
npm install node-rdkafka

// in server/src/events/producer.ts
import kafka from 'node-rdkafka'

const producer = new kafka.HighLevelProducer({
  'metadata.broker.list': process.env.KAFKA_BROKERS,
  'security.protocol': 'sasl_ssl',
  'sasl.mechanism': 'plain',
  'sasl.username': process.env.KAFKA_USER,
  'sasl.password': process.env.KAFKA_PASS,
})

// Emit quiz completion event
export const emitQuizCompleted = (learnerId: string, quizId: string, score: number) => {
  producer.produce(
    'quiz-completed', // topic
    null, // partition (auto)
    Buffer.from(JSON.stringify({ learnerId, quizId, score, timestamp: new Date() })),
    null, // key
  )
}

// Consumer: aggregate daily learner stats
const consumer = new kafka.ConsumerGroupV2({
  'group.id': 'learner-analytics',
  'metadata.broker.list': process.env.KAFKA_BROKERS,
})

consumer.subscribe(['quiz-completed', 'flight-hour-logged'])
consumer.consume((err, msg) => {
  const event = JSON.parse(msg.value.toString())
  // Write to analytics database or trigger notification
})
```

**Topics:**
- `quiz-completed` — score, time spent, module
- `flight-hour-logged` — duration, aircraft, instructor
- `learner-onboarded` — language, timezone, modules selected
- `streak-broken` — module, current streak

---

### 6. Observability (Prometheus + Sentry, Repos #86, #88)

#### Prometheus Metrics

```bash
npm install prom-client

// in server/src/metrics.ts
import { register, Counter, Histogram, Gauge } from 'prom-client'

const requestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request latency',
  labelNames: ['method', 'route', 'status_code'],
})

const quizSubmissions = new Counter({
  name: 'quiz_submissions_total',
  help: 'Total quiz submissions',
  labelNames: ['module', 'passed'],
})

const geminiLatency = new Histogram({
  name: 'gemini_inference_duration_seconds',
  help: 'Gemini API latency',
  labelNames: ['model'],
})

// Middleware
app.use((req, res, next) => {
  const start = Date.now()
  res.on('finish', () => {
    requestDuration
      .labels(req.method, req.route?.path, res.statusCode)
      .observe((Date.now() - start) / 1000)
  })
  next()
})

// Expose metrics for Prometheus scrape
app.get('/metrics', (req, res) => {
  res.set('Content-Type', register.contentType)
  res.end(register.metrics())
})
```

#### Sentry Error Tracking

```bash
npm install @sentry/node

// in server/src/index.ts
import * as Sentry from '@sentry/node'

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  beforeSend(event) {
    // Remove learner PII before sending to Sentry
    if (event.request?.cookies?.auth_token) {
      delete event.request.cookies.auth_token
    }
    return event
  },
})

// Middleware
app.use(Sentry.Handlers.requestHandler())
app.use(Sentry.Handlers.errorHandler())

// Manual error capture
try {
  await processQuizSubmission()
} catch (error) {
  Sentry.captureException(error, {
    tags: { endpoint: '/api/quiz/submit' },
    contexts: { quiz: { quizId } },
  })
}
```

---

## Data Pipeline: ETL with dbt (Repo #43)

**Goal:** Transform raw learner events into analytics tables

```bash
# dbt project structure
dbt/
├── models/
│   ├── staging/  # Raw event transformation
│   │   ├── stg_quiz_events.sql
│   │   ├── stg_flight_hours.sql
│   │   └── stg_learner_interactions.sql
│   └── marts/    # Analytics views
│       ├── learner_progress_daily.sql
│       ├── instructor_class_metrics.sql
│       └── gacar_corpus_freshness.sql
├── tests/        # dbt tests (not null, unique, relationships)
└── dbt_project.yml

# Usage: dbt run (builds models), dbt test (validates data)
```

---

## Testing Strategy

### Unit Tests (Vitest)

```bash
npm install -D vitest @vitest/ui supertest

// test/routes/quiz.spec.ts
import { describe, it, expect } = vitest
import request from 'supertest'
import app from '../src/index'

describe('POST /api/quiz/submit', () => {
  it('should reject invalid request body', async () => {
    const res = await request(app)
      .post('/api/quiz/submit')
      .send({ answers: 'invalid' }) // should be array

    expect(res.status).toBe(400)
    expect(res.body.error).toContain('Invalid request')
  })

  it('should accept valid quiz submission', async () => {
    const res = await request(app)
      .post('/api/quiz/submit')
      .set('Authorization', `Bearer ${token}`)
      .send({
        quizId: 'abc123',
        answers: [{ questionId: 'q1', selectedOptionId: 'opt1' }],
        timeSpent: 300,
      })

    expect(res.status).toBe(200)
    expect(res.body.score).toBeDefined()
  })
})
```

### Load Testing (k6 or Artillery)

```javascript
// load-test.js
import http from 'k6/http'
import { check } from 'k6'

export let options = {
  stages: [
    { duration: '30s', target: 20 },  // ramp up
    { duration: '1m30s', target: 100 }, // peak
    { duration: '20s', target: 0 },   // ramp down
  ],
}

export default function () {
  let response = http.post('https://api.flygaca.com/api/quiz/submit', {
    quizId: 'abc123',
    answers: [],
    timeSpent: 300,
  }, { headers: { Authorization: `Bearer ${token}` } })

  check(response, {
    'status 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  })
}
```

---

## Deployment Checklist

### Pre-Production

- [ ] Security headers (helmet) enabled
- [ ] Rate limiting on auth endpoints
- [ ] JWT tokens in HttpOnly cookies
- [ ] All endpoints validated with Zod schemas
- [ ] Prisma migrations tested locally
- [ ] Database connection pooling configured
- [ ] Prometheus metrics exposed
- [ ] Sentry error tracking configured (PII sanitized)
- [ ] Load testing passed (k6, 100 RPS)
- [ ] CORS headers audited (no `*`)

### Production Deployment

```bash
# Cloud Run deploy with environment variables
gcloud run deploy flygaca-api \
  --source . \
  --region me-central2 \
  --set-env-vars DATABASE_URL=$DATABASE_URL,SENTRY_DSN=$SENTRY_DSN \
  --set-cloudsql-instances=project:me-central2:flygaca-db \
  --allow-unauthenticated
```

---

## References

- [Express 5 Docs](https://expressjs.com)
- [Helmet Docs](https://helmetjs.github.io)
- [express-rate-limit](https://github.com/nfriedly/express-rate-limit)
- [Prisma Docs](https://www.prisma.io/docs/)
- [Zod Validation](https://zod.dev)
- [node-postgres (pg) Guide](https://node-postgres.com)
- [PostgreSQL Best Practices](https://wiki.postgresql.org/wiki/Performance_Optimization)

---

**Maintained by:** Claude Code  
**Last Updated:** 2026-09-11  
**Next Review:** 2026-10-11
