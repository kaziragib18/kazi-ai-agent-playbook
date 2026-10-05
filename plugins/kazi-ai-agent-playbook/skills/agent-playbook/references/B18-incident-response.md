# B18. Incident response (something broke in production)

One path from "something is wrong" to "it won't happen again". It joins the parts that already exist: rollback (OPS-02), kill switches (OPS-12), the runbook (OPS-14), monitoring (OPS-06, OPS-08), the bug workflow (`B10` step 7) and the S1 definition (`B11`).

**Rule zero:** contain first, debug second. The goal of the first minutes is to stop the harm, not to understand it.

| # | Step | What the agent does | Ask the dev? |
|---|---|---|---|
| 1 | **Assess** (≤ 5 min, read-only) | What users see, since when, which deploy (host's deploy list, or `git log` since the last known-good one), how many users. Set the severity: **S1** = data loss, security exposure, payments broken, core loop broken · **S2** = degraded but usable · **S3** = cosmetic. Check the runbook (OPS-14) for a matching entry. | No (read-only) |
| 2 | **Contain** | Propose the smallest step that stops the harm, in this order: turn off the feature (kill switch or flag, OPS-12) → roll back to the last good deploy (OPS-02) → disable the broken route. **Leaked secret:** revoke and rotate the key at the provider first, then remove it from the code. Rewriting git history needs separate approval. | **Yes, always** (G4: production actions). One message: what's broken, the step you propose, what it undoes, the exact command. Have the command ready so the dev's "yes" is acted on in seconds. If the dev can't be reached, keep waiting and keep the draft ready. The agent never acts on production alone, even for an S1. |
| 3 | **Verify containment** | Health endpoint (OPS-05) responds, the error rate is back to normal, the core loop works end to end. Show the output. | No |
| 4 | **Fix forward** on a branch | `B10` step 7: reproduce with a failing test → fix → keep the test. Normal review and CI. A hotfix skips CI only if the dev explicitly says so. Deploy with the dev's OK (G4). | Yes, to deploy |
| 5 | **Tell affected users** (if data or security was involved) | Draft the notice for the dev. Legal notification duties (data-breach deadlines, regulators) are the dev's or a lawyer's call (`modules/legal.md`). The agent never sends anything itself. | Yes |
| 6 | **Postmortem** (≤ 10 lines, blameless) | `docs/incidents/<date>-<slug>.md`: what users saw · timeline · root cause · what stopped it · what prevents a repeat (a test, a Check, an alert, a kill switch). Add or update the runbook entry (OPS-14). If a playbook Check would have caught it, propose that Check (§B14). | Dev reviews |

**Talking to the dev during an incident** (§A5 still applies, with more urgency): lead with impact and the proposed action, not the investigation. Example: "Payments are failing for everyone since the 14:02 deploy. I recommend rolling back to the 13:40 deploy now, which undoes today's checkout change. Command: `vercel rollback <url>`. Shall I run it?"

**Severity sets the pace:** S1 → steps 1-3 now and the fix the same day (`B11`). S2 → contain if cheap, otherwise fix in the next working session. S3 → ticket only.
