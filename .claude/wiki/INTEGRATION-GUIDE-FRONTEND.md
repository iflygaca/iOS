# Frontend Integration Guide: React 19 + Vite Stack

**Scope:** React 19 SPA, Vite bundler, RTL/i18n support, TypeScript strict mode  
**Branch:** `claude/llm-wiki-categorization-wmdgta`  
**Target:** Complete within Q4 2026 and Q1 2027

---

## Current Stack

```
src/
├── pages/           # Route handlers (study, quiz, exam, guides)
├── components/      # Reusable UI (buttons, cards, forms, tables)
├── hooks/          # Custom React hooks (auth, study state, i18n)
├── calc/           # Aviation calculators (crosswind, TAS, fuel, E6B)
├── lib/            # Utilities (date, locale, formatting, crypto)
└── styles/         # CSS Modules + design tokens (Falcon Theme)

key dependencies:
- React 19 (strict mode, ESC mode)
- Vite (bundler, dev server)
- TypeScript (strict)
- React Router (current routing)
- i18next (bilingual EN/AR)
- CSS Modules (design tokens via --css-var)
- Zod (runtime validation)
```

**Bundle Size Target:** <189 kB gzipped (measured at production build)

---

## Immediate Priorities (Q4 2026)

### 1. Routing: TanStack Router (Repo #1)

**Current:** React Router v6  
**Target:** TanStack Router (Type-Safe, Performance)

```bash
# Installation
npm install @tanstack/react-router

# Key benefits over React Router:
# - Full type safety on route params and query strings
# - Better tree-shaking; smaller bundle impact
# - Automatic code-splitting via lazyRouteComponent
# - Nested route layouts with less boilerplate

# Refactor example:
// Before (React Router)
<Routes>
  <Route path="/quiz/:moduleId" element={<QuizPage />} />
</Routes>

// After (TanStack Router)
const quizRoute = new Route({
  getParentRoute: () => rootRoute,
  path: '/quiz/$moduleId',
  component: QuizPage,
})

// Type-safe:
navigate({ to: '/quiz/$moduleId', params: { moduleId: 'elpt' } }) // ✓ compile-time check
```

**Integration Steps:**
1. Install `@tanstack/react-router` and `@tanstack/react-router-devtools`
2. Create route tree in `src/routes.tsx` (replaces individual route files)
3. Migrate top-level routes (study, quiz, exam) incrementally
4. Test RTL navigation (Arabic right-to-left menu order)
5. Verify bundle size: `npm run build && ls -lh dist/`

**Estimated Effort:** 2-3 weeks (phased per route)

---

### 2. Tables: TanStack Table (Repo #2)

**Current:** Manual HTML tables or basic React table  
**Target:** TanStack Table (Headless, Type-Safe)

```bash
npm install @tanstack/react-table

# Key benefits:
# - Headless (no opinionated styling)
# - Server-side pagination, filtering, sorting
# - Column visibility toggles
# - Perfect for learner-progress tables, exam results

# Example: Learner Progress Table
import { useReactTable, getCoreRowModel } from '@tanstack/react-table'

const columns = [
  {
    accessorKey: 'moduleName',
    header: t('table.moduleName'), // i18n
    enableSorting: true,
  },
  {
    accessorKey: 'progress',
    header: t('table.progress'),
    cell: (info) => `${info.getValue()}%`,
  },
]

const table = useReactTable({
  data: learnerProgress,
  columns,
  getCoreRowModel: getCoreRowModel(),
  state: { sorting, columnFilters },
  onSortingChange: setSorting,
})
```

**Where to use:**
- Learner progress view (quiz completions, streaks, SRS boxes)
- Instructor admin panel (student roster, enrollment, flight hours)
- Exam results breakdown (by topic, by difficulty)

**Integration Steps:**
1. Identify 3-5 critical tables
2. Replace with TanStack Table incrementally
3. Wire server-side filtering (if needed for large datasets)
4. Test RTL column order and header alignment
5. Measure bundle impact

**Estimated Effort:** 2-3 weeks

---

### 3. Forms: React Hook Form + Zod (Repos #19, #20)

**Current:** Controlled components or basic form state  
**Target:** React Hook Form + Zod validation

```bash
npm install react-hook-form zod

# Key benefits:
# - Minimal re-renders (uncontrolled form state)
# - Runtime validation via Zod (TypeScript inference)
# - API response shapes match schema
# - Better performance for complex forms

# Example: Study Settings Form
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const settingsSchema = z.object({
  dailyStudyGoal: z.number().min(15).max(480),
  preferredTime: z.enum(['morning', 'afternoon', 'evening']),
  modulesOfInterest: z.array(z.string()),
  language: z.enum(['en', 'ar']),
})

type SettingsFormData = z.infer<typeof settingsSchema>

function StudySettingsForm() {
  const { register, handleSubmit, formState: { errors } } = useForm<SettingsFormData>({
    resolver: zodResolver(settingsSchema),
  })

  const onSubmit = async (data: SettingsFormData) => {
    // type-safe API call
    await api.patch('/me/settings', data)
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('dailyStudyGoal')} type="number" />
      {errors.dailyStudyGoal && <span>{errors.dailyStudyGoal.message}</span>}
      {/* ... */}
    </form>
  )
}
```

**Where to use:**
- Learner onboarding (profile setup, goals, module selection)
- Study settings (daily goals, preferred time, language)
- Exam config (time limit per topic, pass mark)
- Instructor settings

**Integration Steps:**
1. Audit existing forms (count them, identify hotspots)
2. Choose 2-3 critical forms to migrate first
3. Define Zod schemas (export them for API response validation)
4. Replace form state management (remove local useState)
5. Add client-side validation error messages (i18n)

**Estimated Effort:** 1-2 weeks

---

### 4. State Management: Zustand (Repo #18)

**Current:** Redux or Context API  
**Target:** Zustand (Lightweight, Type-Safe)

```bash
npm install zustand

# Key benefits:
# - Simpler than Redux (no boilerplate)
# - Smaller bundle (↓ ~5 kB vs Redux)
# - Works well for study session state
# - TypeScript inference out of the box

# Example: Quiz Session Store
import { create } from 'zustand'

interface QuizSessionState {
  currentQuestionIndex: number
  answers: Map<string, string>
  timeRemaining: number
  
  selectAnswer: (questionId: string, optionId: string) => void
  nextQuestion: () => void
  resetSession: () => void
}

export const useQuizSession = create<QuizSessionState>((set) => ({
  currentQuestionIndex: 0,
  answers: new Map(),
  timeRemaining: 1800, // 30 min
  
  selectAnswer: (questionId, optionId) =>
    set((state) => ({
      answers: new Map(state.answers).set(questionId, optionId),
    })),
  
  nextQuestion: () =>
    set((state) => ({
      currentQuestionIndex: state.currentQuestionIndex + 1,
    })),
  
  resetSession: () =>
    set({
      currentQuestionIndex: 0,
      answers: new Map(),
      timeRemaining: 1800,
    }),
}))

// Usage in component:
function QuizQuestion() {
  const { currentQuestionIndex, selectAnswer } = useQuizSession()
  // component renders
}
```

**Where to use:**
- Quiz session state (current question, selected answers, timer)
- Study progress (current module, completed topics, SRS boxes)
- UI state (modals, filters, view preferences)

**Integration Steps:**
1. Identify Redux stores or Context providers (replace 3-5 at a time)
2. Create Zustand stores in `src/stores/` directory
3. Migrate component subscriptions from Context to Zustand
4. Test with React Devtools (Zustand plugin)
5. Measure bundle reduction

**Estimated Effort:** 1-2 weeks

---

### 5. Data Fetching: SWR (Repo #17)

**Current:** fetch() or axios with manual caching  
**Target:** SWR (Data Fetching + Caching)

```bash
npm install swr

# Key benefits:
# - Automatic cache invalidation
# - Stale-while-revalidate strategy
# - Reduces Redux boilerplate for API state
# - Built-in error handling and retry logic

# Example: Learner Progress Fetch
import useSWR from 'swr'

function LearnerProgressPage() {
  const { data: progress, error, isLoading, mutate } = useSWR(
    '/api/me/progress',
    fetcher,
    { revalidateOnFocus: false } // don't refetch on window focus (save bandwidth)
  )

  if (isLoading) return <Skeleton />
  if (error) return <ErrorCard error={error} />

  return (
    <>
      <ProgressChart data={progress} />
      <button onClick={() => mutate()}>Refresh</button>
    </>
  )
}

// GACAR Corpus Fetch (cache aggressively):
function GACARPart({ partId }: { partId: string }) {
  const { data: part } = useSWR(
    `/api/gacar/parts/${partId}`,
    fetcher,
    { 
      revalidateOnFocus: false,
      revalidateOnReconnect: false,
      dedupingInterval: 3600000, // 1 hour
    }
  )

  return <PartContent part={part} />
}
```

**Where to use:**
- Learner progress (quiz history, streaks, SRS due counts)
- GACAR corpus sections (fetch on demand, cache for 1 hour)
- Instructor roster (paginated, server-side sort/filter)
- Exam packs catalog (cached for session)

**Integration Steps:**
1. Create a `src/lib/fetcher.ts` with Zod validation
2. Replace `useEffect(...fetch())` patterns with `useSWR()`
3. Add error boundary + global SWR config
4. Test offline behavior (SWR cache, stale-while-revalidate)
5. Measure API call reduction

**Estimated Effort:** 1 week

---

## Medium-Term Upgrades (Q1 2027)

### 6. Animations: Framer Motion (Repo #8)

**Use cases:**
- Exam mode transitions (question fade-in/out)
- Quiz progress bar animations
- Learner onboarding flow (slide between steps)
- Toast notifications (slide up)

```bash
npm install framer-motion
```

### 7. Data Visualization: Recharts (Repo #22)

**Use cases:**
- Learner progress dashboard (line chart: study streak)
- Exam results breakdown (bar chart: correct/wrong per topic)
- SRS box distribution (pie chart: cards in box 0-5)
- Instructor class analytics (line chart: learner engagement over time)

```bash
npm install recharts
```

### 8. UI Animations & Visual Polish: Mantine or Material-UI Components

Pair with design tokens from Falcon Theme for consistent styling.

---

## Testing Strategy

### Unit Tests (Vitest)
- Components in isolation with mock data
- Hooks (useQuizSession, useStudyProgress)
- Utilities (date formatting, locale detection)

```bash
npm install --save-dev vitest @vitest/ui
```

### E2E Tests (Playwright)
- Quiz flow (both EN and AR languages)
- Learner onboarding (profile → module selection → first quiz)
- RTL rendering (Arabic text direction, menu order)

```bash
npm install --save-dev @playwright/test

# Run bilingual tests:
# test: AR quiz flow
# test: EN quiz flow
# test: RTL margin/padding calculations
```

### Performance Budget (Lighthouse CI)

Ensure bundle remains <189 kB gzipped:

```bash
npm install --save-dev @lhci/cli@0.9.0 @lhci/server

# In CI: lhci autorun
```

---

## Checklist

- [ ] Migrate routing to TanStack Router
- [ ] Implement TanStack Table for learner-progress view
- [ ] Add React Hook Form + Zod to study-settings form
- [ ] Replace Redux/Context with Zustand for quiz session
- [ ] Integrate SWR for API data fetching
- [ ] Add Vitest + Playwright tests
- [ ] Enable Lighthouse CI (bundle budget enforcement)
- [ ] Audit RTL layout (Arabic learners)
- [ ] Test on mobile (<768px width)
- [ ] Measure bundle impact of each upgrade
- [ ] Deploy to production with feature flags

---

## References

- [TanStack Router Docs](https://tanstack.com/router/latest)
- [TanStack Table Docs](https://tanstack.com/table/latest)
- [React Hook Form Docs](https://react-hook-form.com)
- [Zod Documentation](https://zod.dev)
- [Zustand GitHub](https://github.com/pmndrs/zustand)
- [SWR Documentation](https://swr.vercel.app)
- [Vitest Guide](https://vitest.dev)
- [Playwright Guide](https://playwright.dev)

---

**Maintained by:** Claude Code  
**Last Updated:** 2026-09-11  
**Next Review:** 2026-10-11
