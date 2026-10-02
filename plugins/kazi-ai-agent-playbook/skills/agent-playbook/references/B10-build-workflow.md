# B10. Build workflow: idea → ship (scale each step to task size)


Quality gates (checklist modules) say *what* must hold; this is *how* work flows. Small deliberate steps: the rate of feedback is the speed limit. Each step leaves a file, so any fresh session can resume (§B7).

| # | Step | When | Output (file, not chat) | Skill (examples) / fallback |
|---|---|---|---|---|
| 1 | **Align**: interview until every design branch is resolved; challenge vague terms | New feature, unclear scope, or anything touching data model/auth/money. Skip for tiny well-specified tasks (gate G3) | decisions + open questions in the spec | `grill-me` / `grill-with-docs`, `superpowers:brainstorming` · fallback: numbered question list, one batch per round, stop when nothing is open |
| 2 | **Shared language**: define domain terms once; code, UI copy, tests and tickets use the same words | Project start; whenever a new concept appears | `docs/GLOSSARY.md` (term · meaning · not to be confused with) | `domain-modeling` · fallback: edit the glossary by hand |
| 3 | **Spec** | After align | `docs/specs/<feature>.md`: problem, users, acceptance criteria, non-goals, checklist items in scope, risks, and a **status line** kept current: `Draft` → `Approved <date>` (when the dev says go) → `Built <commit>` (in the same commit as the code). Mark any risk that must be handled first as **blocking** | `to-spec` / `to-prd`, `superpowers:writing-plans` |
| 4 | **Slice**: tracer-bullet vertical slices (each one end-to-end and demoable), dependency edges explicit | Spec has more than one task | plan file or issue tracker, one §B7 task block per slice | `to-tickets` / `to-issues` |
| 5 | **Prototype** (optional): throwaway, answers one design question, then deleted | UX or architecture uncertainty | decision recorded in the spec | `prototype` |
| 6 | **Implement**: before the first edit, set the spec to `Approved <date>` and clear every blocking risk (fixed, or written into the profile's *Accepted exceptions* by the dev); then red → green → refactor for logic; UI verified in a browser | Each slice | code + tests | `tdd`, `superpowers:test-driven-development`, `implement` |
| 7 | **Diagnose** (when broken): reproduce (red) → minimize → hypothesize → instrument → fix → keep the test | Any bug or failing check | regression test + one-line cause in the PR | `diagnosing-bugs`, `superpowers:systematic-debugging` |
| 8 | **Review on two axes**: *standards* (`references/modules/`, project rules, design) and *spec* (does it do what was agreed, nothing more) | Every PR; reviewer is a fresh agent (§B7) | findings list | `code-review` (+ `security-review` if sec routed) |
| 9 | **PR**: summary · evidence (commands + output, screenshots) · checklist items touched (re-check their ledger lines if the change touched their `paths:`) · spec status set to `Built <commit>` · merge-danger call (low/med/high + why: migrations, auth, money, data loss) | Every merge | PR description | `pr` · fallback: this template |
| 10 | **Design upkeep**: prefer deep modules (small interface, much behavior behind it) at clean seams; schedule a deepening/architecture survey | Every few weeks or after a big feature | ranked refactor tickets | `improve-codebase-architecture`, `codebase-design`, `ponytail-audit` |
| 11 | **Retro**: what wasted time or tokens this session → one concrete change to the instruction file, this guide (§B14), the project profile (`docs/agent-profile.md`), or a skill | End of a phase or a painful session | 1-3 lines committed with the next change | `retro` · fallback: write the lines yourself |

Human-only steps (accounts, DNS, secrets, dashboards) are handed to the dev as a numbered checklist or a small interactive script, never left implied (`wizard` skill if present).
