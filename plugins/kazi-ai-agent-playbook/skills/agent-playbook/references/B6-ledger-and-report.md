# B6. Ledger and report formats


The ledger `docs/readiness-ledger.md` is the **only** status store (the project profile (`docs/agent-profile.md`) holds no statuses). Newest first (add new lines at the top), one line per item; record N/A only when a reader would expect the item to apply (e.g. a flag is set but the code has none), `paths` = files the evidence depends on (used by token rule 13):

```
<date> | SEC-50 | FAIL | L3 | no CSP header in host/framework config | paths: <config file> | owner: -
<date> | SEC-10 | PASS | L2 | <handler>:<line> verifies user server-side | paths: <handler files> | verified
```

Final message to dev: `PASS n / FAIL n / N/A n / UNKNOWN n`, then FAILs at or below current level as `ID file:line one-line fix`, then the single next action, then pending decisions from §B5. Nothing else.
