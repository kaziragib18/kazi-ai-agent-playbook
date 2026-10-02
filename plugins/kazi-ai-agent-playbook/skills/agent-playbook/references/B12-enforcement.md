# B12. Mechanical enforcement (make the rules binding)


Advice gets skipped; machines don't skip. Turn on the row for your level and every row above it.

| Level | Enforce with |
|---|---|
| L1 | formatter + linter in the editor; `typecheck`, `lint`, `test` scripts exist |
| L2 | **pre-commit hook** on staged files: format, lint, typecheck, secret scan (e.g. `gitleaks protect --staged`) · **CI** on every PR: frozen install → typecheck → lint → test → build, required to merge on the default branch |
| L3 | + dependency audit in CI and Dependabot/Renovate · E2E smoke test against the preview deploy · branch protection with one review · host-side secret scanning and code scanning (e.g. CodeQL) |
| L4 | + SAST/DAST, bundle/performance budgets in CI, signed releases |

**Agent-level hooks** catch what the agent forgets while it works. In Claude Code they live in the project's `.claude/settings.json` (for example: after each edit, run the formatter and typecheck on that file; when a task stops, run its narrow tests). Set them up with the tool's config skill (`update-config`) and the dev's approval. Other tools: use their rules/hooks feature, or rely on CI. Hooks catch the agent, CI catches everything that slipped past hooks.

Minimal CI (GitHub Actions; swap the setup and commands for the project's language and scripts):

```yaml
name: ci
on: [pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4        # Node + pnpm; use setup-python / setup-go etc. for other stacks
      - uses: actions/setup-node@v4
        with: { node-version: 22, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm typecheck && pnpm lint && pnpm test && pnpm build
```
