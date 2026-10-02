# MODULE perf — PERF speed and cost

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| PERF-01 | L1 | all | Build succeeds; record bundle size per route (build output if it prints sizes; Next.js 16+ does not, so use a bundle analyzer or Lighthouse) | `<pkg manager> build`; analyzer report |
| PERF-02 | L2 | db | Index every FK and every column in hot `WHERE`/`JOIN`/`ORDER BY` | `gg '@@index\|@@unique\|CREATE INDEX' ` vs queries |
| PERF-03 | L2 | db | No N+1 (loop with `await db.`); use include/join/batch | `gg 'await .*(prisma\|db\|repo)\.' $SRC` then read ±10 lines for an enclosing loop/`map(async`; or graph `trace_path` |
| PERF-04 | L2 | db api | Lists paginated (cursor/limit) and select only needed columns (not whole JSON blobs) | list endpoints |
| PERF-05 | L2 | db | Runtime uses the pooled connection URL; direct URL only for migrations; serverless pool size capped | env docs |
| PERF-06 | L2 | api | Long work has a timeout and fits the platform limit; slow jobs go to a queue/background | platform limit vs config (`maxDuration`) |
| PERF-07 | L2 | ui | Debounce autosave/search/resize; coalesce writes | grep debounce |
| PERF-08 | L3 | ui | Route-level code splitting; heavy libs dynamic-imported; marketing routes ship no app JS | analyzer report; `gg 'next/dynamic\|import\('` |
| PERF-09 | L3 | public | Images via framework optimizer (AVIF/WebP, `sizes`, lazy below fold, explicit width/height); fonts self-hosted with `font-display` | `gg '<img '`; font setup |
| PERF-10 | L3 | public | Core Web Vitals on top 3 pages: LCP < 2.5s, INP < 200ms, CLS < 0.1 (record numbers, mobile profile) | `npx lighthouse <url> --only-categories=performance` (ask) |
| PERF-11 | L3 | public | Static/marketing pages cached (ISR/static) with sensible `Cache-Control`; compression on | build output; response headers |
| PERF-12 | L3 | all | Third-party scripts `async/defer`, count minimized | `gg '<script'` |
| PERF-13 | L3 | ui | Memoize only measured hot paths; prefer compiler (React Compiler) over manual `useMemo` sprinkling | framework config |
| PERF-14 | L4 | api | Cache expensive reads (Redis/CDN) with invalidation story; only after a measurement shows need | profile |
| PERF-15 | L4 | all | Budgets in CI (bundle size, Lighthouse CI) and query-time alerts | CI |
