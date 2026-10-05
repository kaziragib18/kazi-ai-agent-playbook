# B17. Model fit (right model before the first edit)

`B4`'s existing model rule covers **delegated sub-agents** (cheap model for grep sweeps, strong model for judgment calls within a task). This section covers the **primary session's own model** — the one the dev is talking to — checked once per fresh session, before any code is written, so a mismatch is caught at the cheapest possible point: before work happens on it, not after.

The agent cannot switch its own model; only the dev can (the tool's model picker — in Claude Code, `/model`). So this is a **recommendation with a reason**, delivered once, never a block.

## When this runs

Inside `B3` preflight step 0, after recon fills level/flags and before routing to the task (`A3`). Runs every fresh session, not only the very first one ever in the repo — a new session can start on any task size.

Skip it when: the task is trivial and the router already sends it to "no-gate, no visible effect" (a typo, a dependency bump) — sizing up a one-line fix costs more than it saves.

## What decides the call

Three signals, already available from work preflight already does — no new analysis step, no extra tool calls:

1. **Gate tier the task hit** (`A1`): G2 (new product) or G3 (user-visible change touching data model/auth/money/public API) → weight toward the stronger model. A no-gate refactor/typo/restore → weight toward the cheaper model.
2. **Blast radius** (`B7` task-sizing signal, already computed when routing): more than ~5 files or more than one module touched → weight toward the stronger model regardless of gate tier.
3. **Level floor** (`A2`, from the profile): L3/L4 → never recommend below the strong model, even for a small diff — money/regulated/scale stakes don't get a budget model. L1 → the cheap/fast model is a legitimate default if shape and gate tier don't override it.
4. **Open-question count** (if `B10` step 1 align ran first): more than ~2 unresolved design branches → weight toward the stronger model even on a small diff — ambiguity is a judgment cost, not a size cost.

These combine by **worst-case, not average**: any one signal calling for the strong model wins. A tiny diff with high ambiguity still gets the strong-model recommendation.

## What to say

One line, plain language (`A5` — no bare labels, no "L3", no gate IDs), only when the current model and the recommendation disagree:

> "This touches [auth / payments / the data model / N files across M areas], so I'd recommend switching to a stronger model before I start — mismatches here are expensive to redo. If you want to continue on the current model anyway, say so and I will."

Or the inverse, only if the dev asked and tokens matter to them (don't volunteer a downgrade suggestion unprompted — it reads as the agent avoiding work):

> "This is a small, well-specified change; a faster/cheaper model would handle it fine if you want to save budget."

Then **proceed on the current model** if the dev doesn't respond or says to continue — this is advisory, never a gate. Record the recommendation and the dev's choice in the project profile's *Decisions* (`assets/profile-template.md`) so it isn't re-asked on an unrelated follow-up in the same session, but re-check on the next fresh session (task shape changes).

## What this is not

Not a replacement for `B4`'s sub-agent model rule (that still applies to delegated sweeps regardless of what the primary session is running on). Not a gate like G1-G6 — nothing here blocks an edit; a dev who says "continue anyway" is answered, not overridden. Not a judgment on the dev's choice of model for the session as a whole (they may be on a fixed plan/budget) — one line, stated once, dropped if unanswered.
