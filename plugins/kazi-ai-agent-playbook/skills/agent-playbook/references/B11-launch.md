# B11. Launch, first week, ongoing cadence


**Before launch (release check):** run §B3 at the brief's level; every FAIL at or below the level is fixed or written into the project profile (`docs/agent-profile.md`) *Accepted exceptions* by the dev · rollback steps tested once (OPS-02) · analytics/consent decision made (LEG-04) · support contact visible · backups confirmed (OPS-03) · if the product calls paid APIs, a monthly budget is recorded and spend is visible (AI-16). Monitoring follows the level like every other item: at L3+ error tracking and an uptime monitor are live (OPS-06, OPS-08); at L2 they are recommended, and at minimum the dev knows where the host's error logs are and someone reads them daily during week one.

**Launch day:** deploy in working hours with someone watching · no unrelated merges · watch errors and the core value loop for the first hours · if the core loop or payments break, follow `B18-incident-response.md` (contain first, debug second).

**First week (daily, 10 minutes):** top 5 new errors by count · the core-loop funnel against the brief's success metric · yesterday's paid-API spend against the daily share of the budget (if any) · user feedback · each issue becomes a ticket with a severity. **S1 fixed the same day:** data loss, security exposure, payments broken, core loop broken.

**End of week one:** metric vs target · retro (§B10 step 11) · update the brief with what was learned · re-order the plan.

**Ongoing cadence:**
- **Weekly:** dependency updates and audit (SEC-51) · spend review if the product calls paid APIs (AI, email, rendering, storage): total this week, cost per active user, top 5 users by cost, against the budget in the profile's *Decisions*; record the numbers as one AI-16 ledger line; a week-over-week jump above 50% or a projected budget overrun becomes a ticket.
- **Monthly:** backup restore check at L3+ (OPS-10).
- **Every few weeks:** architecture survey (§B10 step 10).
- **Before each major release:** re-run the release check at the current level.
