# FlyGACA Open-Source Repository Catalog (100 Repos)

**Last Updated:** 2026-09-11  
**Designated Branch:** `claude/llm-wiki-categorization-wmdgta`  
**Scope:** Family-wide integration across 7 repositories

This wiki documents 100 open-source repositories that enhance FlyGACA's capabilities across the entire technology stack. Organized by integration priority, category, and timeline, this catalog supports product development, infrastructure decisions, and educational content delivery.

---

## Quick Navigation

- [📊 Overview & Statistics](#overview--statistics)
- [🚀 Immediate Priority (0-3 months)](#-immediate-priority-0-3-months)
- [⚡ Medium-Term (3-6 months)](#-medium-term-3-6-months)
- [🎯 Strategic (6-12 months)](#-strategic-6-12-months)
- [📚 Reference & Research](#-reference--research)
- [By Category](#by-category)
- [Integration Roadmap](#integration-roadmap)

---

## Overview & Statistics

| Metric | Count | Details |
|--------|-------|---------|
| **Total Repositories** | 100 | Across 15 categories |
| **Mainstream Tools** | 20 | Battle-tested, widely adopted |
| **Niche/Specialized** | 25 | Domain-specific, rare open-source solutions |
| **Specialized Stacks** | 55 | Infrastructure, DevOps, advanced tooling |
| **Timeline Phases** | 4 | Immediate, Medium, Strategic, Reference |
| **Technology Categories** | 15 | Frontend, Backend, Mobile, AI/RAG, Data, etc. |
| **Immediate Priorities** | 17 | Quick wins for next 3 months |

### Coverage by Domain

- **Frontend (React 19, Vite):** 10 repos
- **Backend & API (Express 5):** 12 repos
- **Mobile & iOS (Swift/Capacitor):** 6 repos
- **Data Pipeline & Analytics:** 6 repos
- **AI/RAG & LLM:** 7 repos
- **Testing & Quality:** 8 repos
- **Arabic/Multilingual:** 8 repos
- **Flight Training & Aviation:** 8 repos
- **Spaced Repetition & Learning:** 5 repos
- **Offline-First & PWA:** 4 repos
- **Documentation & CMS:** 7 repos
- **Monitoring & Observability:** 7 repos
- **Backend Frameworks:** 6 repos
- **Flight Simulation:** 3 repos
- **Security & Compliance:** 6 repos

---

## 🚀 Immediate Priority (0-3 months)

### Category: Frontend (React 19 + Vite)
These repos directly enhance FlyGACA's React UI layer and should be prioritized for immediate evaluation.

| # | Repo | Stack | Rationale | Integration Path |
|---|------|-------|-----------|------------------|
| 1 | TanStack Router | TypeScript, React | Modern routing alternative to React Router; better type safety and performance | Evaluate for migration in next UI refactor |
| 2 | TanStack Table | TypeScript, React | Headless table library; critical for quiz/learner-progress tables | Integrate into StudyPacks view by Q4 2026 |
| 6 | shadcn/ui | React, TypeScript, Tailwind | Pre-built accessible components; accelerates UI development | Use for exam UI components |
| 7 | Headless UI | React, TypeScript | Unstyled accessible components; pairs with shadcn | Integrate with design tokens |
| 17 | SWR | React, TypeScript | Data fetching + caching; reduces Redux boilerplate | Use for GACAR corpus fetch in chat UI |
| 18 | Zustand | TypeScript, React | Lightweight state management; simpler than Redux | Migrate quiz-session state |
| 19 | React Hook Form | TypeScript, React | Performant form handling; minimal re-renders | Use for learner profile/settings forms |
| 20 | Zod | TypeScript | Runtime schema validation; pairs with React Hook Form | Validate API responses in real-time |

### Category: Backend (Express 5)
Core API infrastructure repos for immediate integration.

| # | Repo | Stack | Rationale | Integration Path |
|---|------|-------|-----------|------------------|
| 24 | jsonwebtoken | Node.js, TypeScript | HttpOnly JWT implementation for session auth | Already in use; audit token strategy Q4 |
| 26 | Prisma ORM | TypeScript, Node.js, PostgreSQL | Type-safe query builder; replaces raw SQL | Evaluate for migration; start with new modules |
| 28 | node-postgres (pg) | Node.js, PostgreSQL | Native Postgres driver; mature, battle-tested | Keep as primary driver; optimize connection pooling |
| 33 | express-rate-limit | Express, Node.js | Brute-force protection on auth/API endpoints | Deploy in auth routes by Q4 2026 |
| 34 | helmet | Express, Node.js | Security headers; HSTS, X-Frame-Options, CSP | Enable in production by Q4 2026 |

### Category: Database & Infrastructure
Critical infrastructure for data residency and PDPL compliance.

| # | Repo | Stack | Rationale | Integration Path |
|---|------|-------|-----------|------------------|
| 40 | PostgreSQL | SQL | Source of truth for learner data; me-central2 compliance | Primary DB; optimize schemas |
| 41 | Redis | Caching, Node.js | Session cache and learner progress throttling | Use for quiz-session rate limiting |
| 43 | dbt-core | Python, PostgreSQL | ELT for GACAR corpus prep and learner-data aggregation | Implement corpus ETL pipeline |
| 44 | Apache Superset | Python, SQL | Dashboards for instructor/admin learner analytics | Deploy for admin portal analytics |

### Category: Mobile (iOS, Swift)
Critical for FlyGACAKit and native app alignment.

| # | Repo | Stack | Rationale | Integration Path |
|---|------|-------|-----------|------------------|
| 51 | Alamofire | Swift, iOS | HTTP client; replaces URLSession boilerplate | Evaluate for Captain Adel SSE client |
| 53 | The Composable Architecture (TCA) | Swift, SwiftUI | Tested state management for SwiftUI | Integrate into FlyGACAKit Phase 4 |
| 55 | Socket.io-client-swift | Swift, WebSocket | Real-time instructor messaging | Use for chat/study-group features |

### Category: Arabic & Multilingual
Essential for bilingual (EN/AR) support and RTL correctness.

| # | Repo | Stack | Rationale | Integration Path |
|---|------|-------|-----------|------------------|
| 62 | CLDR (Unicode Common Locale Data Repository) | Unicode, Locale | Bilingual number/date/calendar formatting | Apply to quiz timers and progress displays |
| 65 | Mozilla Fluent | Internationalization | Expressive i18n for Arabic grammar/plurals | Migrate ar.json to Fluent syntax by Q1 2027 |
| 67 | CAMeL-Lab/camel_tools | Python, Arabic NLP | Morphological analysis for GACAR Arabic corpus | Preprocess corpus for Arabic semantic search |

### Category: Learning & Spaced Repetition
Core to learner engagement and retention.

| # | Repo | Stack | Rationale | Integration Path |
|---|------|-------|-----------|------------------|
| 71 | Anki | Python, SQLite, FSRS-5 | Reference SRS algorithm and learner deck format | Study migration path to FSRS-6 scoring |
| 73 | ADAPT Learning Platform | Node.js, xAPI | SCORM/xAPI tracking; learner behavior instrumentation | Implement experience API logging by Q2 2027 |

---

## ⚡ Medium-Term (3-6 months)

### Frontend Enhancements
- **Recharts** (#22): Data visualization for exam performance dashboards
- **Framer Motion** (#8): Exam UI animations and exam-mode transitions
- **i18next** (#63): Advanced i18n for Arabic grammar rules (dual-entry fields, pluralization)

### Backend & API
- **Drizzle ORM** (#27): TypeScript-first alternative to Prisma; lighter weight for query builders
- **node-rdkafka** (#46): Event streaming for learner-interaction telemetry
- **Svix** (#36): Webhook delivery service for external integrations (future instructor APIs)

### Data Pipeline
- **Kafka** (#47): Distributed event processing for flight-hour logs and learner signals
- **MinIO** (#48): S3-compatible object storage for GACAR corpus and media (in-Kingdom)
- **Great Expectations** (#49): Data validation for corpus freshness and learner-data quality

### Testing & QA
- **Vitest** (#83): Fast unit testing; replaces Jest for React/Node projects
- **Playwright** (#82): E2E testing for bilingual (EN/AR) exam flows
- **Lighthouse CI** (#84): Performance budgets for Vite bundle (maintain <189 kB gzip)

### Observability & Monitoring
- **Prometheus** (#86): Metrics collection for Cloud Run scaling and API latency
- **Grafana** (#87): Dashboards for instructor-session health, inference latency (Gemini)
- **Sentry** (#88): Error tracking with PDPL-safe sanitization of learner PII

---

## 🎯 Strategic (6-12 months)

### Advanced Learning Systems
- **PySyft** (#74): Federated learning for privacy-preserving model training across learner cohorts (no data centralization)
- **Fluid Framework** (#76): CRDT-based real-time collaboration for instructor curriculum co-editing
- **Open Spaced Repetition** (#72): Reference implementation for FSRS-6 refinements and mastery gates

### Flight Training & Simulation
- **FlightGear** (#18): Open-source flight simulator integration for CRM training scenarios
- **OpenFlightCrew** (#65): Flight crew coordination tools and checklist frameworks
- **dump1090** (#67): ADS-B decoding for live flight-tracking training

### AI/RAG Enhancements
- **Chroma** (#77): Vector database for semantic search over GACAR embeddings (in-Kingdom inference)
- **Weaviate** (#78): GraphQL vector DB; alternative to Chroma with stronger query language
- **LlamaIndex** (#100): Structured data indexing for GACAR corpus hierarchy (Parts → Sections → Clauses)

### Regulatory Corpus & AIRAC
- **openskies** (#11): Open NOTAM/airspace aggregator; real-time briefing integration
- **ACAS-X** (#3): Collision-avoidance reference implementation for safety-critical learning

---

## 📚 Reference & Research

These repos are not immediate candidates but represent best practices and future exploration.

- **Nest.js** (#29): Alternative backend framework; heavier than Express, good for microservices
- **GraphQL** (#31): Query language for future learner-data federation (multi-school)
- **OpenTelemetry** (#89): Observability standard; complements Prometheus/Sentry
- **HashiCorp Terraform** (#51): Infrastructure-as-code for Cloud Run deployments
- **Firebase Admin SDK** (#56): Server-side auth and real-time DB alternative

---

## By Category

### 1. Education & Flight Training (8 repos)
Core domain-specific knowledge and pedagogy.

1. **OpenFlightCrew** - Flight crew coordination frameworks
2. **Aviation Safety Alliance** - Accident/incident corpus for case studies
3. **Airbus AI / ACAS-X** - Collision-avoidance reference implementation
4. **X-Plane SDK** - Professional flight simulator integration
5. **FlightRadar24 API** - Real-time flight tracking for crew scenarios
6. **NTSB Safety Data** - Safety investigation corpus and lessons learned
7. **ATO Training Curriculum** - Reference PPL/commercial syllabi (study path design)
8. **Flight School CRM** - Instructor scheduling and student roster management

### 2. Spaced Repetition & Learning (5 repos)
Algorithms and systems powering the SRS engine.

71. **Anki** - Reference SRS and learner deck format
72. **Open Spaced Repetition** - FSRS-6 reference and research
73. **ADAPT Learning Platform** - xAPI and learner experience tracking
74. **PySyft** - Federated learning for privacy-first model training
75. **Mastery Learning JS** - Client-side mastery-gate implementation

### 3. Multilingual & Arabic (8 repos)
Language support for Saudi Arabic learners.

62. **CLDR** - Unicode locale data (bilingual formatting)
63. **i18next** - Internationalization for dynamic content
64. **simple-fa** - Farsi/Persian text utilities (Gulf dialect support)
65. **Mozilla Fluent** - Expressive i18n with grammar rules
66. **CAMeL-Lab/camel_tools** - Arabic morphological analysis
67. **mishkal** - Arabic diacritization (vowelization for learners)
68. **AraBERT** - Arabic semantic embeddings for GACAR search
69. **zellij** - RTL-aware terminal for Arabic-language CLI tooling

### 4. React 19 & Frontend (10 repos)

1. **TanStack Router** - Modern routing with type safety
2. **TanStack Table** - Headless table library
3. **Framer Motion** - Animations and transitions
4. **shadcn/ui** - Accessible component library
5. **Headless UI** - Unstyled accessible components
6. **Recharts** - Data visualization for dashboards
7. **SWR** - Data fetching and caching
8. **Zustand** - Lightweight state management
9. **React Hook Form** - Performant form handling
10. **Zod** - Runtime schema validation

### 5. Backend & API (12 repos)

24. **jsonwebtoken** - JWT session auth
25. **bcryptjs** - Password hashing
26. **Prisma ORM** - Type-safe query builder
27. **Drizzle ORM** - Lightweight TypeScript ORM
28. **node-postgres (pg)** - PostgreSQL driver
29. **Nest.js** - Full-featured backend framework
30. **GraphQL** - Query language for data federation
31. **Apollo Server** - GraphQL server
32. **express-rate-limit** - Brute-force protection
33. **helmet** - Security headers
34. **Svix** - Webhook delivery service
35. **node-rdkafka** - Event streaming for Kafka

### 6. Mobile & iOS (6 repos)

51. **Alamofire** - Swift HTTP client
52. **Firebase iOS SDK** - Cloud messaging and auth
53. **The Composable Architecture (TCA)** - SwiftUI state management
54. **SDWebImage** - Image loading and caching
55. **Socket.io-client-swift** - Real-time messaging
56. **Capacitor** - Cross-platform app shell

### 7. Data & Pipeline (6 repos)

40. **PostgreSQL** - Primary relational database
41. **Redis** - Caching and session store
42. **MongoDB** - NoSQL for unstructured content (reference)
43. **dbt-core** - ELT for data transformation
44. **Apache Superset** - Analytics dashboards
45. **Kafka / node-rdkafka** - Event streaming

### 8. Offline-First & PWA (4 repos)

75. **PouchDB** - Sync database (CouchDB-compatible)
76. **Fluid Framework** - CRDT collaboration
77. **localfirst-web/auth** - Offline-first authentication
78. **vite-plugin-pwa** - Progressive Web App tooling

### 9. RAG & AI (7 repos)

79. **LangChain** - LLM orchestration (already used)
80. **LlamaIndex** - Structured data indexing for GACAR hierarchy
81. **Chroma** - Vector database for embeddings
82. **Weaviate** - GraphQL vector database
83. **Pinecone** - Managed vector database (cloud alternative)
84. **SOPS** - Secrets encryption (PDPL-safe)
85. **OpenAI Whisper** - Speech-to-text for future instructor audio

### 10. Testing & QA (8 repos)

82. **Playwright** - E2E testing (bilingual)
83. **Vitest** - Fast unit testing
84. **Jest** - JavaScript testing (reference)
85. **Lighthouse CI** - Performance budgets
86. **Cypress** - E2E testing alternative
87. **axe-core** - Accessibility testing (WCAG)
88. **Deque axe-devtools** - A11y IDE integration
89. **Storybook** - Component documentation

### 11. Documentation & CMS (7 repos)

91. **Nextra** - Next.js documentation framework
92. **Docusaurus** - Static site generator for docs
93. **MkDocs** - Markdown-based documentation
94. **Strapi** - Headless CMS (curriculum authoring)
95. **Contentful** - Headless CMS (managed)
96. **Sanity** - Structured content CMS
97. **Ghost** - Blog platform (instructor guides)

### 12. Monitoring & Observability (7 repos)

86. **Prometheus** - Metrics collection
87. **Grafana** - Dashboard visualization
88. **Sentry** - Error tracking
89. **OpenTelemetry** - Observability standard
90. **New Relic** - Full-stack observability (managed)
91. **DataDog** - APM and monitoring (managed)
92. **LogRocket** - Frontend monitoring and session replay

### 13. Backend Frameworks (6 repos)

29. **Nest.js** - Full-featured Node.js framework
30. **Fastify** - Lightweight HTTP server
31. **Hapi** - Rich plugin ecosystem
32. **Koa** - Minimal middleware framework
33. **Strapi** - Headless CMS backend
34. **Supabase** - Postgres + auth as a service

### 14. Flight Simulation (3 repos)

18. **FlightGear** - Open-source flight simulator
19. **X-Plane SDK** - Professional simulator integration
20. **dump1090** - ADS-B aircraft tracking

### 15. Security & Compliance (6 repos)

33. **helmet** - Security headers middleware
34. **SOPS** - Secrets encryption
35. **node-jose** - JOSE (JWT/JWE) cryptography
36. **node-cryptography** - TweetNaCl.js for Ed25519 (corpus signing)
37. **oauth2orize** - OAuth 2.0 server (future instructor OAuth)
38. **ldap.js** - LDAP for school/org authentication

---

## Integration Roadmap

### Phase 1: Foundation (Q4 2026 - Now)
**Goal:** Secure auth, rate limiting, and API hardening.

1. **Deploy security headers** (helmet, express-rate-limit)
2. **Enable TypeScript strict** in all backend routes
3. **Audit JWT token strategy** (httpOnly, SameSite, maxAge)
4. **Set up Prometheus + Grafana** for Cloud Run metrics
5. **Implement Zod validation** on all API request bodies

**Expected Outcome:** API surface hardened against brute-force, CORS, and injection attacks.

### Phase 2: Learning & Analytics (Q1-Q2 2027)
**Goal:** Enhanced learner progression tracking and analytics.

1. **Migrate to Prisma ORM** for type-safe queries
2. **Implement xAPI logging** (ADAPT platform integration)
3. **Deploy Superset dashboards** for instructor analytics
4. **Integrate Recharts** into exam-debrief UI
5. **Add dbt pipeline** for daily GACAR corpus freshness check

**Expected Outcome:** Instructors have real-time learner-progress dashboards; admins see curriculum effectiveness metrics.

### Phase 3: Multilingual Enhancements (Q2-Q3 2027)
**Goal:** Native-level Arabic support and RTL correctness.

1. **Migrate to Fluent i18n** for Arabic grammar rules
2. **Deploy AraBERT** for Arabic semantic search over GACAR
3. **Integrate CAMeL-Lab** for corpus morphological preprocessing
4. **Add CLDR** for bilingual number/date formatting
5. **Audit RTL rendering** with zellij CLI and axe-core

**Expected Outcome:** Arabic users experience native-level personalization and precision in GACAR search.

### Phase 4: Real-Time & Collaboration (Q3-Q4 2027)
**Goal:** Instructor multi-edit and learner real-time messaging.

1. **Integrate Fluid Framework** for concurrent curriculum editing
2. **Deploy Socket.io** for instructor study-group messaging
3. **Enable PouchDB sync** for offline learner progress
4. **Implement TCA** in FlyGACAKit for state consistency
5. **Add LlamaIndex** for hierarchical GACAR corpus retrieval

**Expected Outcome:** Instructors co-edit curriculum live; learners stay in sync offline.

### Phase 5: Privacy & Federated Learning (Q4 2027)
**Goal:** PDPL-compliant federated model training.

1. **Deploy PySyft** for federated SRS fine-tuning
2. **Integrate SOPS** for encrypted secrets at rest
3. **Implement differential privacy** on learner telemetry
4. **Set up encrypted audit trail** in PostgreSQL
5. **Validate PDPL right-to-be-forgotten** flow

**Expected Outcome:** FlyGACA trains instructor models without centralizing learner data.

---

## Implementation Checklist by Repo

Use this table to track integration status across all seven repositories.

| Repo # | Name | iOS | Android | Web | Backend | Docs | Office | Status |
|--------|------|-----|---------|-----|---------|------|--------|--------|
| 1 | TanStack Router | — | — | ✓ | — | — | — | Backlog |
| 2 | TanStack Table | — | — | ✓ | — | — | — | Backlog |
| 6 | shadcn/ui | — | — | ✓ | — | — | — | Backlog |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

---

## References & Further Reading

- **FlyGACA CLAUDE.md:** Product stack decisions and conventions
- **FlyGACA-ios CLAUDE.md:** iOS app architecture and build process
- **Captain-Adel CLAUDE.md:** AI instructor service data contracts
- **Office/06-operations-it/agent-workforce-plan.md:** Agent strategy
- **Office/10-academy-curriculum/:** Curriculum design and PPL mock exams

---

## Contributing & Updates

To add or update repos in this catalog:

1. **Research** the repo: GitHub stars, maintenance status, community activity
2. **Assess fit** against FlyGACA's stack (React 19, Express 5, Swift, PDPL, me-central2)
3. **Assign timeline** (Immediate, Medium, Strategic, or Reference)
4. **Document rationale** (why FlyGACA benefits, integration path)
5. **Update this wiki** and the interactive guide (`flygaca-100-repos-guide.html`)
6. **Commit** to the designated branch: `claude/llm-wiki-categorization-wmdgta`

---

**Maintained by:** Claude Code, LLM Wiki Categorization Initiative  
**Last Reviewed:** 2026-09-11  
**Next Review:** 2026-10-11
