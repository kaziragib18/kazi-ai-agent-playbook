# B13. Versioning, calibration, pilot


- **Version** lives in the plugin's `plugin.json` and the SKILL.md header: bump the minor version for added or reworded items, the major version when the protocol or gates change. Add one changelog line per change.
- **Calibrate per project:** after the first three tasks, run a retro (§B10 step 11): which rules were skipped, which Checks gave false hits (→ fix the Check or add an accepted exception), which Checks needed translating (→ the project profile (`docs/agent-profile.md`)). Feed general lessons back into the skill (§B14) through a PR to the plugin repo.
- **Pilot before calling a version stable:** use it on at least three different project types (for example a new MVP, an existing API in another language, a static landing page) and record the result in the changelog.
- **Measure tokens (optional):** when the tool shows usage, add `tokens: <n>` to the handoff note. Compare tasks of a similar size to find where context leaks.

**Changelog**
- v4.0 · 2026-10-02 · core/playbook split (always-loaded part about 1.5k tokens) · hard gates G1-G6 · task router · Phase 0 for new products · launch and first-week loop · mechanical enforcement · product → skills table · versioning, calibration and pilot rules.
- v3 · 2026-10-01 · modules with levels and tags · recon script · skill registry and budget · session hygiene · coding rules · idea → ship workflow · `gg` check helper (escaped pipes fixed) · motion rules.
- Pilot status: exercised on one existing Next.js repo only; not yet piloted on other stacks or a greenfield project.
