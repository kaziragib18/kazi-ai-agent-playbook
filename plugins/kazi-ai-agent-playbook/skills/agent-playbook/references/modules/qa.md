# MODULE qa — QA testing and delivery

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| QA-01 | L1 | all | One documented command runs the app and one runs tests | manifest scripts (`package.json`, `Makefile`, `pyproject.toml`) or, for a static/no-build app, the commands written in README or `CLAUDE.md` (e.g. "open index.html", "node test.js") |
| QA-02 | L1 | all | Typecheck + lint pass (no-build static app: a syntax check such as `node --check <file>` plus the test command) | the project's commands; paste the last lines of output |
| QA-03 | L2 | all | Core business logic (pure functions, reducers, calculators, parsers, migrations) has unit tests; a new bug fix ships with a test that failed before | recon test count; `git diff` includes test |
| QA-04 | L2 | api | Each handler has tests for 401 unauthenticated, 400 invalid body, 403/404 someone else's object, 2xx happy path | recon `api route tests`; compare to route list |
| QA-05 | L2 | db | Repository/DB tests run against a throwaway database, not prod | test config; env |
| QA-06 | L2 | all | External services (LLM, payments, email) are mocked in tests; no network in unit tests | `gg 'vi\.mock\|jest\.mock\|msw' $SRC` |
| QA-07 | L3 | all | CI runs install(frozen) → typecheck → lint → test → build and is a required status on the default branch | `ls .github/workflows`; branch protection (ask dev) |
| QA-08 | L3 | ui auth | E2E on the critical path: signup/login → core action → persist → export/checkout | Playwright spec or MCP run |
| QA-09 | L3 | auth | Auth flows: login, logout, expired session mid-edit (no data loss), password/magic-link recovery | E2E |
| QA-10 | L3 | ui | Responsive smoke at 390/768/1280 and one non-Chromium browser | Playwright projects |
| QA-11 | L3 | render | Visual/PDF regression: screen render vs export diffed after template/layout changes | project regression script |
| QA-12 | L3 | db | Migrations apply cleanly on an empty DB and on a copy with data; backward compatible with the running version (expand → deploy → contract) | run in CI |
| QA-13 | L3 | all | Flaky tests are fixed or quarantined with an issue, never retried silently | CI history |
| QA-14 | L4 | api | Load test of the hottest endpoint with a stated budget (p95, error rate) | k6/artillery report |
| QA-15 | L4 | all | Chaos cases: network loss, timeouts, 5xx from dependencies, huge/malformed payloads | tests/E2E |
| QA-16 | L4 | ui | Automated a11y (axe) in CI on key pages | workflow |

Rule for any test the agent writes: it must fail when the logic breaks. Run it once against a deliberately broken implementation or `git stash` of the fix.
