# B11. Launch, first week, ongoing cadence


**Before launch (release check):** run §B3 at the brief's level; every FAIL at or below the level is fixed or written into the project profile (`docs/agent-profile.md`) *Accepted exceptions* by the dev · rollback steps tested once (OPS-02) · error tracking and an uptime monitor live (OPS-06, OPS-08) · analytics/consent decision made (LEG-04) · support contact visible · backups confirmed (OPS-03).

**Launch day:** deploy in working hours with someone watching · no unrelated merges · watch errors and the core value loop for the first hours · rollback first, debug second if the core loop or payments break.

**First week (daily, 10 minutes):** top 5 new errors by count · the core-loop funnel against the brief's success metric · user feedback · each issue becomes a ticket with a severity. **S1 fixed the same day:** data loss, security exposure, payments broken, core loop broken.

**End of week one:** metric vs target · retro (§B10 step 11) · update the brief with what was learned · re-order the plan.

**Ongoing cadence:** weekly dependency updates and audit (SEC-51) · monthly backup restore check at L3+ (OPS-10) · architecture survey every few weeks (§B10 step 10) · re-run the release check at the current level before each major release.
