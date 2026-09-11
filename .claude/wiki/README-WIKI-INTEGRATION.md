# FlyGACA 100-Repository Wiki & Integration Guide

**Date Created:** 2026-09-11  
**Designated Branch:** `claude/llm-wiki-categorization-wmdgta`  
**Scope:** Family-wide (7 repositories)  
**Audience:** Engineers, product managers, infrastructure team

---

## 📚 What This Is

This wiki documents **100 open-source repositories** selected for integration across the FlyGACA family. It provides:

1. **Repository Catalog** — 100 repos organized by category, timeline, and domain
2. **Focused Integration Guides** — Step-by-step implementation for frontend, backend, iOS
3. **Roadmap & Checklist** — Sequenced deployment timeline (Q4 2026 → Q4 2027)
4. **Interactive HTML Guide** — Searchable directory with filterable views

The goal: accelerate FlyGACA's development by curating battle-tested open-source solutions and minimizing "reinventing the wheel" on critical infrastructure.

---

## 📖 Documents in This Wiki

| Document | Purpose | Audience | Read Time |
|----------|---------|----------|-----------|
| **WIKI-100-REPOS-CATEGORIZATION.md** | Complete 100-repo catalog with categories, timelines, integration paths | Everyone | 20-30 min |
| **INTEGRATION-GUIDE-FRONTEND.md** | React 19 + Vite stack — routing, forms, state, data fetching, animations | Frontend Engineers | 15-20 min |
| **INTEGRATION-GUIDE-BACKEND.md** | Express 5 + Node.js — security, validation, ORM, observability, data pipeline | Backend/DevOps | 20-25 min |
| **INTEGRATION-GUIDE-MOBILE.md** | iOS/Swift — state management, networking, real-time, testing, Capacitor | Mobile Engineers | 15-20 min |
| **README-WIKI-INTEGRATION.md** | This file — overview and navigation | Everyone | 10 min |
| **flygaca-100-repos-guide.html** | Interactive searchable directory (open in browser) | Everyone | Self-paced |

---

## 🚀 Quick Start

### For Product Managers
1. Open `WIKI-100-REPOS-CATEGORIZATION.md` and scan the "Immediate Priority" section (17 quick-win repos)
2. Skim the "Integration Roadmap" (5 phases over 12 months)
3. Share timeline with engineering leads for sprint planning

### For Frontend Engineers
1. Read `INTEGRATION-GUIDE-FRONTEND.md` (45 minutes)
2. Pick 2-3 repos from the Q4 2026 priorities to start with
3. Create a feature branch and begin migration planning

### For Backend/DevOps Engineers
1. Read `INTEGRATION-GUIDE-BACKEND.md` (50 minutes)
2. Focus on security hardening first (helmet, rate limiting, Zod validation)
3. Plan Prisma ORM migration for the next sprint

### For Mobile Engineers
1. Read `INTEGRATION-GUIDE-MOBILE.md` (45 minutes)
2. Evaluate The Composable Architecture (TCA) for FlyGACAKit
3. Plan Alamofire integration for Captain Adel SSE client

### For Everyone
1. Browse `flygaca-100-repos-guide.html` in a web browser
2. Search for specific keywords (e.g., "Arabic", "testing", "database")
3. Filter by timeline phase to see what's relevant to your sprint

---

## 📊 By The Numbers

| Metric | Count | Notes |
|--------|-------|-------|
| **Total Repositories** | 100 | Curated for FlyGACA stack |
| **Immediate Priorities** | 17 | Deploy in Q4 2026 (0-3 months) |
| **Medium-Term** | 25+ | Q1-Q2 2027 (3-6 months) |
| **Strategic** | 30+ | Q3-Q4 2027 (6-12 months) |
| **Reference** | 25+ | Research, not immediate |
| **Technology Categories** | 15 | Frontend, backend, mobile, data, AI, etc. |
| **Integration Guides** | 3 | Frontend, backend, mobile (specialized) |

---

## ⚡ Immediate Priority Repos (Q4 2026)

### Frontend (React 19)
- **TanStack Router** — Modern type-safe routing
- **TanStack Table** — Headless table library for progress views
- **shadcn/ui** — Pre-built accessible components
- **React Hook Form + Zod** — Performant form validation
- **Zustand** — Lightweight state management
- **SWR** — Data fetching + caching

### Backend (Express 5)
- **helmet** — Security headers (CSP, HSTS, etc.)
- **express-rate-limit** — Brute-force protection
- **Prisma ORM** — Type-safe query builder
- **Zod** — Runtime request validation
- **Postgres** — Primary database
- **Prometheus + Sentry** — Observability

### Mobile (iOS/Swift)
- **The Composable Architecture (TCA)** — Testable state management
- **Alamofire** — HTTP networking
- **Socket.io-client-swift** — Real-time messaging
- **SDWebImage** — Image caching

---

## 📅 Deployment Timeline

### Phase 1: Foundation (Q4 2026)
**Goal:** Security and stability hardening.
- Deploy helmet + rate limiting
- Implement Zod validation on all endpoints
- Audit JWT token strategy
- Setup Prometheus/Grafana/Sentry

**Repos:** 5-6 (security-focused)

### Phase 2: Learning & Analytics (Q1-Q2 2027)
**Goal:** Enhanced learner progress tracking.
- Migrate to Prisma ORM
- Deploy xAPI logging (ADAPT platform)
- Integrate Superset dashboards
- Implement dbt ETL pipeline

**Repos:** 6-8 (data pipeline)

### Phase 3: Multilingual Enhancements (Q2-Q3 2027)
**Goal:** Native-level Arabic support.
- Migrate to Mozilla Fluent i18n
- Deploy AraBERT for Arabic search
- Integrate CAMeL-Lab morphological analysis
- Audit RTL rendering

**Repos:** 4-5 (Arabic/i18n)

### Phase 4: Real-Time & Collaboration (Q3-Q4 2027)
**Goal:** Instructor multi-edit, learner sync.
- Integrate Fluid Framework (CRDT collaboration)
- Deploy Socket.io for real-time messaging
- Enable PouchDB offline sync
- Implement TCA for iOS state management

**Repos:** 5-6 (real-time)

### Phase 5: Privacy & Federated Learning (Q4 2027 & beyond)
**Goal:** PDPL-compliant model training.
- Deploy PySyft for federated learning
- Integrate SOPS for encrypted secrets
- Implement differential privacy
- Validate right-to-be-forgotten flow

**Repos:** 4-5 (privacy/compliance)

---

## 🛠️ Repo Integration Checklist

Use this table to track which repos have been:
- **Researched** (PR review, proof-of-concept)
- **Evaluated** (team assessment, bundle impact measured)
- **Committed** (merged into main branch)
- **Deployed** (running in production)

Example format:

| Repo | Category | Researched | Evaluated | Committed | Deployed | Status |
|------|----------|:----------:|:---------:|:---------:|:--------:|--------|
| TanStack Router | Frontend | ✅ | ⏳ | — | — | Sprint 45 |
| Helmet | Backend | ✅ | ✅ | ✅ | — | Ready for Q4 |
| TCA | Mobile | ✅ | ⏳ | — | — | Backlog |

---

## 🎯 Key Decision Points

### 1. Monorepo vs. Multi-Repo Structure
**Decision:** Keep current multi-repo (7 separate repositories) to avoid merge conflicts.
**Impact on Repos:** Async dependencies (web must deploy before iOS can consume new corpus).

### 2. ORM: Prisma vs. Drizzle
**Recommendation:** Start with Prisma (stronger ecosystem, more examples).
**Fallback:** Drizzle if bundle size becomes critical.

### 3. State Management: Redux vs. Zustand vs. TCA
**Frontend:** Zustand (simpler, smaller)  
**Mobile:** TCA (testable, composable)  
**Backend:** None (Express services, no client state)

### 4. i18n: i18next vs. Mozilla Fluent
**Current:** i18next with ar.json manual dictionary  
**Target:** Mozilla Fluent (better Arabic grammar rules, pluralization)  
**Timeline:** Q2 2027 (not blocking initial work)

### 5. AI/RAG: Chroma vs. Weaviate vs. Pinecone
**Recommendation:** Chroma (open-source, in-Kingdom inference via embeddings server)  
**Constraint:** Must run in me-central2 (Dammam) for PDPL compliance

---

## 🔐 Security & Compliance Considerations

All 100 repos have been screened for:

- **PDPL Compliance:** No centralized learner data (encrypted, audit trail)
- **ZATCA/Tax:** Not applicable (SaaS backend, no invoicing needed)
- **MISA (IP):** Open-source licenses verified (MIT, Apache 2.0, BSD)
- **Malware/Supply Chain Risk:** Known projects only (GitHub stars, community, maintenance status)
- **Data Residency:** Cloud Run me-central2 (Dammam) only — Chroma/embeddings cannot leave Kingdom
- **External Inference:** Gemini API calls (US-based) — **documented open risk**, not hidden

---

## 🤝 Contributing & Maintenance

To add or update repos in this wiki:

1. **Research** the repo (maintenance status, community, security)
2. **Assess fit** against FlyGACA stack (React 19, Express 5, Swift, PDPL, me-central2)
3. **Assign timeline** (Immediate, Medium, Strategic, Reference)
4. **Write rationale** (why FlyGACA benefits, integration path)
5. **Update wiki files** (`WIKI-100-REPOS-CATEGORIZATION.md`, guides, this README)
6. **Create PR** to the `claude/llm-wiki-categorization-wmdgta` branch
7. **Get approval** from engineering leads before merging to main

---

## 📂 File Structure in This Wiki

```
claude/llm-wiki-categorization-wmdgta/
├── README-WIKI-INTEGRATION.md                    (this file)
├── WIKI-100-REPOS-CATEGORIZATION.md              (main catalog)
├── INTEGRATION-GUIDE-FRONTEND.md                 (React/Vite implementation)
├── INTEGRATION-GUIDE-BACKEND.md                  (Express/Node implementation)
├── INTEGRATION-GUIDE-MOBILE.md                   (iOS/Swift implementation)
├── flygaca-100-repos-guide.html                  (interactive searchable guide)
└── [future] INTEGRATION-GUIDE-DATA.md            (dbt, ETL, analytics pipeline)
```

All files are committed to the designated branch across 7 repositories:
- `iflygaca/ios`
- `iflygaca/FlyGACA-ios`
- `iflygaca/Captain-Adel-iOS`
- `iflygaca/Captain-Adel`
- `iflygaca/FlyGACA`
- `iflygaca/FlyGACA-Family`
- `iflygaca/Office`

---

## 📞 Questions & Support

| Question | Where to Find Answer |
|----------|---------------------|
| "What repos should we prioritize?" | `WIKI-100-REPOS-CATEGORIZATION.md` → Immediate Priority section |
| "How do I add TanStack Router?" | `INTEGRATION-GUIDE-FRONTEND.md` → Router: TanStack Router (Repo #1) |
| "How do I set up Prisma?" | `INTEGRATION-GUIDE-BACKEND.md` → ORM Migration: Prisma |
| "How do I implement TCA?" | `INTEGRATION-GUIDE-MOBILE.md` → State Management: TCA |
| "What's the timeline?" | `WIKI-100-REPOS-CATEGORIZATION.md` → Integration Roadmap |
| "Is repo X suitable for FlyGACA?" | `flygaca-100-repos-guide.html` → search & filter |

---

## 🎓 Training & Onboarding

New engineers joining FlyGACA should:

1. **Read:** This README (10 min)
2. **Skim:** Relevant integration guide (frontend/backend/mobile, 20 min)
3. **Browse:** Interactive HTML guide (self-paced)
4. **Ask:** Team lead which 2-3 repos to focus on in first sprint

**Total onboarding:** 45 minutes to become familiar with the open-source strategy.

---

## ✅ Quality Assurance

Every repo in this catalog has been vetted for:

- **GitHub stars & forks** (community validation)
- **Maintenance status** (recent commits, open issues resolved)
- **License compatibility** (MIT, Apache 2.0, BSD only — no GPL)
- **Bundle impact** (measured for frontend repos)
- **PDPL/compliance** (no PII leakage, in-Kingdom capable)
- **Documentation quality** (readable examples, TypeScript support)

---

## 📝 Commit Conventions

When working on this wiki:

```bash
# Branch name
git checkout -b claude/llm-wiki-categorization-wmdgta

# Commit message format
git commit -m "docs: add TanStack Router integration example

- Include step-by-step migration path
- Measure bundle impact
- Link to official docs
- Test RTL layout (Arabic)

Refs: WIKI-100-REPOS #1"
```

---

## 🔄 Next Steps

1. **Product Leads:** Review Immediate Priority section, share timeline with team
2. **Frontend Team:** Start with TanStack Router POC
3. **Backend Team:** Begin security hardening (helmet + rate-limit)
4. **Mobile Team:** Evaluate TCA for FlyGACAKit Phase 4
5. **All Teams:** Bookmark the interactive HTML guide for reference

---

**Last Updated:** 2026-09-11  
**Next Review:** 2026-10-11  
**Maintained by:** Claude Code, LLM Wiki Categorization Initiative

---

## 📚 Related Documents

- **FlyGACA/CLAUDE.md** — Product stack conventions
- **FlyGACA-ios/CLAUDE.md** — iOS app architecture
- **Captain-Adel/CLAUDE.md** — AI flight instructor service
- **Office/06-operations-it/agent-workforce-plan.md** — Team structure & responsibilities
- **Office/contracts/flygaca-family.json** — Cross-repo contract & entity facts
