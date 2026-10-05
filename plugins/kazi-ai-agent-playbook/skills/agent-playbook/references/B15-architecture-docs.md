# B15. Architecture docs (full + essentials)

Two files, two audiences. Both are generated, not optional prose the dev writes alone — the agent drafts from the stack decision (new product) or from the actual code (`B16` mid-project backfill), the dev corrects.

| File | Audience | Size | When it changes |
|---|---|---|---|
| `docs/ARCHITECTURE.md` | Deep reference: full system design, data flow, every subsystem, the reasoning behind non-obvious decisions | As long as it needs to be | Edited when an architectural decision changes (new subsystem, storage change, auth model change) — not every commit |
| `docs/ARCHITECTURE-ESSENTIALS.md` | What a fresh session (agent or dev) must know before touching code: the few invariants that are easy to violate and expensive to unwind | Under ~200 lines; if it grows past that, move detail to `ARCHITECTURE.md` and link | Kept current **every session** that touches architecture — see "Drift rule" below |

## Generating `ARCHITECTURE.md`

Sections, in order: system overview (one diagram or paragraph) · components and their responsibilities · data flow for the 1-2 flows that matter most · storage/schema shape and why · external integrations and their failure modes · the non-obvious decisions and the reasoning (link `docs/decisions/*.md` ADRs instead of repeating them) · known limitations and deferred items.

New product: draft from the approved stack decision (`B2` step 2) and the brief, after the walking skeleton proves the shape works (`B2` step 4) — don't document an architecture that hasn't been exercised once end to end.

Mid-project: draft from the code via `B16`'s recon pass, not from assumption.

## Generating `ARCHITECTURE-ESSENTIALS.md`

This is the file a fresh agent reads first, before `ARCHITECTURE.md`. Keep every line load-bearing:

- **Invariants**: rules that are easy to break by accident and expensive to unwind (a boundary that must never import from another layer, a format that must survive a round-trip, an ordering that must hold). State the rule and the one-sentence reason, not the full history.
- **Commands**: how to build, run, test — or a pointer to `CLAUDE.md` if already there (don't duplicate; one of the two owns each fact).
- **Gotchas**: version deviations from the obvious default, footguns already hit once (a prior incident is worth a line; a hypothetical one is not).
- **Pointers**: where to look for more (`ARCHITECTURE.md` section, an ADR, a module's own README) — this file summarizes, it does not replace.

Model this on whatever the project already does well; a project with its own `ARCHITECTURE-ESSENTIALS.md` convention (format, section order) keeps that convention — this reference sets the floor, not a template to overwrite it with.

## Drift rule (the part that is usually skipped)

A stale architecture doc is worse than no doc — it actively misleads the next session. So:

- **At the end of any task that changed architecture** (new subsystem, changed data flow, new invariant, a decision that would surprise the next reader): update `ARCHITECTURE-ESSENTIALS.md` in the **same commit** as the change (`B8` rule 11, "docs travel with code"). This is not optional cleanup — an architecture change without the doc update is not Done.
- **The moment drift is noticed** (the doc says X, the code does Y), fix the doc or flag it to the dev — don't leave it for later; a later session has no way to know the doc was already known-stale.
- **At the end of a long/multi-task session**, the handoff note (`B7`) states whether `ARCHITECTURE-ESSENTIALS.md` still matches what was built; if not, fixing it is the first line of the next session's task, not an afterthought.

## Precedence with other doc conventions

If the project already has its own architecture-doc convention under a different name (e.g. its `CLAUDE.md` names specific files and rules for keeping them current), that convention wins (`B9` precedence) — this reference exists so a project **without** one gets a sane default, and so the agent recognizes the pattern and follows it correctly when the project already has it.
