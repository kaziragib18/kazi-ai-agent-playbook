# B13. Versioning, calibration, pilot


- **Version** lives in the plugin's `plugin.json` and the SKILL.md header: bump the minor version for added or reworded items, the major version when the protocol or gates change. Add one changelog line per change.
- **Calibrate per project:** after the first three tasks, run a retro (§B10 step 11): which rules were skipped, which Checks gave false hits (→ fix the Check or add an accepted exception), which Checks needed translating (→ the project profile (`docs/agent-profile.md`)). Feed general lessons back into the skill (§B14) through a PR to the plugin repo.
- **Pilot before calling a version stable:** use it on at least three different project types (for example a new MVP, an existing API in another language, a static landing page) and record the result in the changelog.
- **Measure tokens (optional):** when the tool shows usage, add `tokens: <n>` to the handoff note. Compare tasks of a similar size to find where context leaks.

**Changelog**
- v4.0.4 · 2026-10-02 · `gg` splits a space-separated `$SRC` that zsh passes as one argument (it silently returned "no match", a false PASS, in the macOS default shell).
- v4.0.3 · 2026-10-02 · `gg`/recon search untracked files in a git repo with no commits (no more silent false PASS) and use grep for matching, so `\b` works on macOS · stale profile `commit: none` triggers re-recon · recon no longer prints `fatal: HEAD` before the first commit · flat projects get their code files as `SRC` instead of `.` · Phase 0 drafts brief and stack together and asks once · specs carry a status line (Draft → Approved → Built) and blocking risks must be fixed or accepted before the first edit · PRs re-check ledger lines whose paths changed · `gg` reports a bad pattern as an error (exit 2) instead of a silent no-match · ledger lines go on top, N/A only when non-obvious.
- v4.0.2 · 2026-10-02 · preflight flags over-installed pick-one skills (style presets, workflow packs) · browser tools: serve static apps on localhost instead of `file:` · `gg` ignores missing paths without git (no false error) · QA-01/02 and SEC-01 work for static and non-git projects.
- v4.0.1 · 2026-10-02 · scripts and freshness rules work without git (plain grep/find fallback) · UX-01 also scans .html/.js/.ts/.astro · profile routes only items at or below the level.
- v4.0 · 2026-10-02 · core/playbook split (always-loaded part about 1.5k tokens) · hard gates G1-G6 · task router · Phase 0 for new products · launch and first-week loop · mechanical enforcement · product → skills table · versioning, calibration and pilot rules.
- v3 · 2026-10-01 · modules with levels and tags · recon script · skill registry and budget · session hygiene · coding rules · idea → ship workflow · `gg` check helper (escaped pipes fixed) · motion rules.
- Pilot status: exercised on one existing Next.js repo only; not yet piloted on other stacks or a greenfield project.
