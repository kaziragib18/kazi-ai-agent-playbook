# B2. Phase 0: new product from nothing (gate G2)


For an empty or near-empty repo, or "build me X". Gate G2: only steps 1-2 run until the dev approves them. Each step leaves a file.

| # | Step | Output | Done when |
|---|---|---|---|
| 1 | **Product brief**: align interview (§B10 step 1) on the dev's idea, then a one-page brief | `docs/PRODUCT-BRIEF.md`: one target persona · problem and today's workaround · the core value loop (the one action users come back for) · MVP must-haves and won'ts · success metric with a target · constraints (budget, deadline, regions, compliance, team skills) · monetization (none / later / now) · proposed level and flags | dev approves the brief |
| 2 | **Stack decision**: 2-3 options compared, one chosen | `docs/decisions/0001-stack.md` (context · options · decision · consequences · exit path) | dev approves |
| 3 | **Repo setup** | official starter of the chosen framework · lockfile committed · `.env.example` · `CLAUDE.md` with the §B1 pointer line · the project profile (`docs/agent-profile.md`) profile filled (recon now works) · `docs/GLOSSARY.md` seeded with the brief's terms · enforcement baseline for the level (§B12) | typecheck, lint and test scripts run green |
| 4 | **Walking skeleton**: the thinnest end-to-end slice on a real URL: sign-in (if `auth`) → one real core action → saved → visible | deployed preview URL (production deploy only with the dev's OK, G4) + CI running | live URL works and CI is green |
| 5 | **MVP plan**: slice the must-haves into vertical slices, **riskiest first** (payments, AI quality, data model, third-party limits) | `docs/plans/mvp.md`, one §B7 task block per slice | dev agrees on the order |
| 6 | **Build loop** per slice: §B10 steps 6-9 | merged slices | each slice's Done-when seen |
| 7 | **Launch** at the brief's level | §B11 | release check clean or exceptions accepted |

**Stack-choice criteria (in order):** team familiarity → fit for the flags (e.g. `ai`, `pay`, `render`) → hosting limits and cost at the expected scale (free-tier caps, function timeouts, idle pauses, commercial-use terms) → lock-in and exit path → maturity and documentation quality. **Defaults:** boring and well documented; one language end to end unless a flag needs otherwise; managed services over self-hosting at L1-L3; confirm payment and AI providers support the dev's country and target regions; no microservices, queues or caches before a measured need.
