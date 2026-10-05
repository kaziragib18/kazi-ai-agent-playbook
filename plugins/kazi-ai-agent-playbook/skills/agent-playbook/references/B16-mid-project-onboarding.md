# B16. Mid-project onboarding (jumping into an existing codebase)

For a repo that is **not** empty (so `B2` Phase 0 does not apply) **and** has no project profile, or a profile with missing/stale doc pointers. Goal: reach the same shared understanding Phase 0 gives a new product, but derived from the code that already exists instead of an interview — then hand the dev a short correction pass instead of a blank page.

This is not a one-time setup ritual — it is the normal first session on any repo the agent has not worked in before. It runs quietly inside the existing preflight (`B3` step 0), not as a separate announced phase.

## 0. Detect

During preflight (`B3` step 0), after recon, check for each of the five docs:

| Doc | Present and fresh | Present but stale | Missing |
|---|---|---|---|
| `docs/agent-profile.md` | normal preflight (`B3` step 0) | re-run recon | run recon now, this triggers the rest |
| `docs/PRODUCT-BRIEF.md` (or project's own PRD) | skip | note in profile, ask once whether to refresh | backfill (§2) |
| `docs/ARCHITECTURE.md` | skip | skip (edited on architecture change only, see `B15`) | backfill (§2) |
| `docs/ARCHITECTURE-ESSENTIALS.md` | skip if its content still matches a quick recon spot-check | backfill (§2) | backfill (§2) |
| `AGENTS.md` / `CLAUDE.md` | skip | skip (dev-owned; note drift once, don't rewrite) | backfill minimal version (§2), ask approval first — this file is dev-owned |

"Stale" = the doc's content contradicts what recon or a grep actually finds (a named stack that isn't in the manifest, a file path that doesn't exist, a flag the doc doesn't mention). A doc that is merely old but still accurate is not stale.

If all five are present and fresh: proceed with the normal task, no backfill needed, say nothing extra to the dev.

## 1. Decide backfill scope

Backfill only the **missing or stale** docs, not all five reflexively. Say in one line which are missing before starting: "This repo doesn't have a product brief or architecture summary yet — I'll draft both from the code so we're both working from the same picture, then you correct what I got wrong." This is informational, not a gate question — proceed, don't wait for a reply, unless the task is tiny enough that drafting four docs would be disproportionate (then ask first, §3).

## 2. Backfill: derive from code, not assumption

Same output shape as `B2`/`B15`, different source:

- **`docs/PRODUCT-BRIEF.md`**: derive persona/problem/value-loop from the UI copy, routes, and data model, not invention — "this app has a signup flow, a dashboard with X, and a Y export" is evidence; a persona narrative is not. Mark every field the code cannot answer (success metric, monetization, constraints) as **"unknown — dev to fill"** rather than guessing. Flags/level proposed the same way as Phase 0, from recon.
- **`docs/ARCHITECTURE.md`** and **`docs/ARCHITECTURE-ESSENTIALS.md`** (open `references/B15-architecture-docs.md` for their shape): walk the actual source tree — entry points, the data layer, the boundaries that exist in the code today (even if unlabeled), integrations found in the manifest/env. State what the code does, not what it should do; a messy real boundary is documented as-is, with a note if it looks unintentional, not cleaned up in the doc while the code stays messy.
- **`AGENTS.md`/`CLAUDE.md`** minimal version: commands that actually run (from manifest scripts, verified once), the stack, and a pointer to `ARCHITECTURE-ESSENTIALS.md` — nothing speculative. **Ask before creating or editing either file** (`B5`): they are dev-owned instruction files (`B9`), and an agent-authored rewrite of a dev's existing conventions is exactly the kind of surprise `B5`/G4 exists to prevent. If one already exists, add only the missing pointer line (`B1`), never restructure it.

Every backfilled doc gets one line at its top: `<!-- Backfilled from code on <date>; dev: please correct -->`, removed once the dev confirms or edits it.

## 3. Confirm, don't block

Backfilled docs are a draft, not a gate (unlike `B2`'s brief/stack approval, G2 does not apply here — the product already exists and is already running). Proceed with the actual task using the draft; ask the dev to skim and correct it at a natural pause (end of the task, or the next time something in the draft would change a decision), batched with anything else pending (`B5`). Exception: if the task itself is large enough that Phase-0-level rigor is warranted (a major new feature, a rewrite) — then treat it like `B10` step 1 (align) and get confirmation before building on an unconfirmed draft.

## 4. After backfill

Fill `docs/agent-profile.md` exactly as Phase 0 would have (recon flags/level, routing table, source dirs). From here the session proceeds exactly as `A3`'s task router says for the actual task the dev asked for — this section only gets the docs to a usable starting state, it does not replace the task.
