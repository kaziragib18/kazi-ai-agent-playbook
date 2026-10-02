# B6. Ledger and report formats


The ledger `docs/readiness-ledger.md` is the **only** status store (the project profile (`docs/agent-profile.md`) holds no statuses). Newest first (add new lines at the top). **Start every check run with a header line** so the latest run can be found: `## Run <date> · commit <sha or none> · level <L> · checked: <modules or "release">`, followed by one line per item; record N/A only when a reader would expect the item to apply (e.g. a flag is set but the code has none), `paths` = files the evidence depends on (used by token rule 13):

```
<date> | SEC-50 | FAIL | L3 | no CSP header in host/framework config | paths: <config file> | owner: -
<date> | SEC-10 | PASS | L2 | <handler>:<line> verifies user server-side | paths: <handler files> | verified
```

Final message to the developer, in plain language (see SKILL.md §A5), in this order and nothing else:
1. One line of totals in words, counting **only checks that apply at the current level** (not N/A, not higher levels): "I checked 24 things for a free beta: 18 are fine, 4 need fixing, 2 I couldn't check from the code."
2. Each problem that needs fixing: what is wrong in everyday words, where it is (`file:line`), the fix; the item ID may follow in brackets. Example: "Deleting a book has no undo or confirmation, so one mis-tap loses it; add an Undo toast (app.js:76) (UX-07)."
3. What couldn't be checked and what you need from them to check it.
4. The single next step you recommend.
5. Any decisions waiting on them, each with why it matters.
6. Optional, one line each: "Looking ahead: N more things would apply at a public launch (e.g. legal pages, monitoring)" and "You have unsaved changes in X; commit them before release."
Never use bare labels such as "PASS 18 / FAIL 4", "UX-07 FAIL" or "N/A at L1" in chat; those belong in the ledger file.
