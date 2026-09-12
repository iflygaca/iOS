# Sprint 1: Staging Environment Setup Runbook (Sep 25–30)

## Overview

This runbook guides the infrastructure and QA teams through three phases of pre-Sprint-1 preparation:
- **Phase 1: Environment Parity (Sep 25–26)** — Cloud Run staging, Cloud SQL staging, monitoring setup
- **Phase 2: Load-Test Harness (Sep 27–28)** — Artillery/K6 scenarios, test data, baseline metrics
- **Phase 3: CI/CD Integration (Sep 29–30)** — GitHub Actions staging workflow, smoke tests, rollback procedures

Sprint 1 formally begins **Oct 1, 2026** with simultaneous launch of Helmet, rate-limit, and Prometheus tasks.

---

## Phase 1: Environment Parity (Sep 25–26)

### Task 1.1: Cloud Run Staging Environment

**Owner:** DevOps Lead  
**Duration:** 4 hours (Sep 25, morning)  
**Success Criteria:** Staging Cloud Run service accepts traffic, health check responds, logs visible in Cloud Logging

#### Steps

1. **Create Cloud Run service (staging)**
   ```bash
   gcloud run deploy flygaca-staging \
     --image=gcr.io/flygaca-project/api:latest \
     --platform=managed \
     --region=me-central2 \
     --memory=2Gi \
     --cpu=2 \
     --min-instances=0 \
     --max-instances=5 \
     --allow-unauthenticated \
     --project=flygaca-project
   ```

2. **Set environment variables**
   ```bash
   gcloud run services update flygaca-staging \
     --set-env-vars="ENVIRONMENT=staging,DATABASE_URL=postgresql://...,LOG_LEVEL=DEBUG" \
     --region=me-central2 \
     --project=flygaca-project
   ```

3. **Verify service health**
   ```bash
   curl https://flygaca-staging-[hash].me.a.run.app/health
   ```
   Expected response: `{ "status": "ok" }`

4. **Check logs**
   ```bash
   gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=flygaca-staging" \
     --limit=50 \
     --format=json \
     --project=flygaca-project
   ```

5. **Record staging service URL** → Slack notification to #devops

---

### Task 1.2: Cloud SQL Staging Environment

**Owner:** DevOps Lead  
**Duration:** 2 hours (Sep 25, late morning)  
**Success Criteria:** PostgreSQL instance exists, test database created, Cloud Run service connects successfully

#### Steps

1. **Create Cloud SQL instance (staging)**
   ```bash
   gcloud sql instances create flygaca-staging-db \
     --database-version=POSTGRES_15 \
     --tier=db-custom-2-8192 \
     --region=me-central2 \
     --availability-type=REGIONAL \
     --enable-bin-log \
     --backup-start-time=02:00 \
     --project=flygaca-project
   ```

2. **Create staging database**
   ```bash
   gcloud sql databases create flyg_staging \
     --instance=flygaca-staging-db \
     --project=flygaca-project
   ```

3. **Create app user**
   ```bash
   gcloud sql users create app_staging \
     --instance=flygaca-staging-db \
     --password=[GENERATE_RANDOM_24_CHARS] \
     --project=flygaca-project
   ```

4. **Apply schema migrations** (from `server/migrations/`)
   ```bash
   # Use Cloud SQL Proxy or network connectivity to run:
   psql postgresql://app_staging:PASSWORD@IP/flyg_staging < migrations/001_init.sql
   ```

5. **Verify connection from Cloud Run**
   - Deploy a simple test image that logs "Database OK" to Cloud Logging
   - Confirm log entry appears within 30 seconds

6. **Record database URL** → Store in GitHub Secret `STAGING_DATABASE_URL`

---

### Task 1.3: Monitoring Setup (Cloud Logging, Cloud Trace, Cloud Profiler)

**Owner:** DevOps Lead  
**Duration:** 2 hours (Sep 25, afternoon)  
**Success Criteria:** Logs appear in DEBUG level, Cloud Trace samples 100%, Profiler initialized

#### Steps

1. **Enable Cloud Logging with DEBUG level**
   ```bash
   gcloud run services update flygaca-staging \
     --set-env-vars="LOG_LEVEL=DEBUG" \
     --region=me-central2 \
     --project=flygaca-project
   ```

2. **Configure log retention (7 days)**
   ```bash
   gcloud logging sinks update _Default \
     --log-filter='resource.type="cloud_run_revision" AND resource.labels.service_name="flygaca-staging"' \
     --retention-days=7 \
     --project=flygaca-project
   ```

3. **Enable Cloud Trace (100% sample rate)**
   - Trace all incoming requests for baseline analysis
   ```bash
   gcloud run services update flygaca-staging \
     --set-env-vars="TRACING_SAMPLE_RATE=1.0" \
     --region=me-central2 \
     --project=flygaca-project
   ```

4. **Enable Cloud Profiler**
   - Ensure service has IAM role `roles/cloudprofiler.agent`
   ```bash
   gcloud projects add-iam-policy-binding flygaca-project \
     --member="serviceAccount:flygaca-sa@flygaca-project.iam.gserviceaccount.com" \
     --role="roles/cloudprofiler.agent"
   ```

5. **Verify monitoring data**
   - Visit Cloud Console → Cloud Logging → check for DEBUG entries
   - Visit Cloud Console → Cloud Trace → verify 10+ traces captured
   - Visit Cloud Console → Cloud Profiler → verify CPU profile exists

6. **Create monitoring dashboard**
   - Name: `flygaca-staging-health`
   - Charts:
     - Cloud Run request latency (p50/p95/p99)
     - Error rate (5xx responses)
     - Active instances
     - Trace latency distribution

**Verification Checklist (Sep 25, end-of-day)**
- [ ] Cloud Run service running at `flygaca-staging-[hash].me.a.run.app`
- [ ] Cloud SQL `flyg_staging` database accessible
- [ ] Health endpoint responds 200 OK
- [ ] Cloud Logging shows DEBUG entries
- [ ] At least 10 traces in Cloud Trace
- [ ] Monitoring dashboard created and accessible
- [ ] #devops Slack notification posted with service URLs and credentials location

---

## Phase 2: Load-Test Harness Setup (Sep 27–28)

### Task 2.1: Artillery/K6 Test Scenarios

**Owner:** QA Lead  
**Duration:** 8 hours (Sep 27–28)  
**Success Criteria:** All three scenarios run without errors, baseline metrics collected

#### Scenario 1: Baseline Load (Sustained)
- **Name:** `baseline-5min`
- **Load Profile:** 100 concurrent users over 5 minutes
- **Endpoints:**
  - GET /health (every 500ms, all users)
  - GET /api/quiz/:id (10% of users every 10s)
  - POST /api/chat (5% of users every 20s, 200-char payload)
- **Success Criteria:**
  - p50 latency < 100ms
  - p95 latency < 500ms
  - p99 latency < 2000ms
  - Error rate < 0.5%

#### Scenario 2: Rate-Limit Brute-Force Test
- **Name:** `rate-limit-brute-force`
- **Load Profile:** 20 concurrent users attempting 10 failed auth per user (total 200 failures over 10 minutes)
- **Endpoint:** POST /api/auth/login (with invalid credentials)
- **Success Criteria:**
  - First 5 failures per IP succeed (HTTP 401)
  - 6th–10th failures are rate-limited (HTTP 429)
  - Rate-limit reset after 15 minutes

#### Scenario 3: Observability Test
- **Name:** `observability-10min`
- **Load Profile:** 500 users over 10 minutes (10 users/sec ramp-up)
- **Endpoints:**
  - GET /health
  - GET /api/quiz/:id
  - POST /api/chat
- **Success Criteria:**
  - Prometheus metrics scraped successfully
  - `http_request_duration_seconds` histogram populated
  - Grafana dashboard shows live data
  - Cloud Trace latency distribution matches histogram

---

## Phase 3: CI/CD Integration (Sep 29–30)

### Task 3.1: GitHub Actions Staging Deploy Workflow

**Owner:** DevOps Lead  
**Duration:** 4 hours (Sep 29)  
**Success Criteria:** Workflow runs successfully, staging service updated via GitHub Actions, smoke tests pass

#### Smoke Test Script (`scripts/smoke-test-staging.sh`)

```bash
#!/bin/bash
set -e

STAGING_URL="https://flygaca-staging-[hash].me.a.run.app"
RETRIES=5
TIMEOUT=10

echo "Running smoke tests against $STAGING_URL"

# Test 1: Health endpoint
echo "Test 1: Health endpoint..."
for i in $(seq 1 $RETRIES); do
  if curl -s -m $TIMEOUT "$STAGING_URL/health" | grep -q "ok"; then
    echo "✅ Health endpoint OK"
    break
  fi
  echo "  Retry $i/$RETRIES..."
  sleep 2
done

# Test 2: Metrics endpoint (Prometheus)
echo "Test 2: Prometheus metrics endpoint..."
curl -s -m $TIMEOUT "$STAGING_URL/metrics" | grep -q "http_request_duration_seconds" && \
  echo "✅ Prometheus metrics OK" || echo "❌ Prometheus metrics FAILED"

# Test 3: API health (quiz endpoint)
echo "Test 3: Quiz API endpoint..."
curl -s -m $TIMEOUT "$STAGING_URL/api/quiz/1" | grep -q "id" && \
  echo "✅ Quiz API OK" || echo "❌ Quiz API FAILED"

# Test 4: Authentication (should 401 without token)
echo "Test 4: Auth endpoint (expect 401)..."
curl -s -m $TIMEOUT -o /dev/null -w "%{http_code}" "$STAGING_URL/api/me" | grep -q "401" && \
  echo "✅ Auth endpoint OK" || echo "❌ Auth endpoint FAILED"

echo "Smoke tests completed"
```

---

## Sign-Off

**Phase 1 Complete:** Sep 26, evening  
**Phase 2 Complete:** Sep 28, afternoon  
**Phase 3 Complete:** Sep 30, afternoon  

**Ready for Sprint 1 Kickoff: Oct 1, 9:00 AM UTC**

Signed off by:
- [ ] DevOps Lead
- [ ] QA Lead
- [ ] Backend Lead
- [ ] Orchestrator

---

## Appendix: Quick Reference

### Critical URLs
- Staging API: `https://flygaca-staging-[hash].me.a.run.app`
- Cloud Console: `https://console.cloud.google.com/run/detail/me-central2/flygaca-staging`
- Cloud SQL: `flygaca-staging-db` in `me-central2`

### Slack Channels
- `#devops` — Infrastructure updates
- `#engineering` — Load test results, baseline metrics
- `#phase-1-sprint-1` — Sprint 1 daily standup & blockers
