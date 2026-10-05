# MODULE ops — OPS delivery and recovery

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| OPS-01 | L1 | all | README: setup, env vars, run, test, deploy in < 15 lines; `.env.example` complete | read README |
| OPS-02 | L2 | all | Deploy is one command/merge; previous deployment can be re-promoted (rollback < 2 min) and the steps are written down | ops doc |
| OPS-03 | L2 | db | Backups: provider tier known (free tiers often lack point-in-time recovery); scheduled dump to separate storage if not | ops doc; workflow |
| OPS-04 | L2 | all | Free-tier/quotas known (DB size, bandwidth, function time, idle pause) with a keep-alive or alert where the platform pauses | `vercel.json` crons etc. |
| OPS-05 | L2 | all | Health endpoint that checks the DB (cheap query), no secrets in output | recon `health` + route exists |
| OPS-06 | L3 | all | Error tracking (client + server + route handlers) with PII scrubbed and release tagging | `package.json` sentry/bugsnag |
| OPS-07 | L3 | all | Structured JSON logs at request boundaries with request id; no PII | logger |
| OPS-08 | L3 | all | Uptime monitor on `/` and health, alert to a human | dev confirms |
| OPS-09 | L3 | all | CI/CD: see QA-07; preview deploys per PR; protected default branch | workflows |
| OPS-10 | L3 | db | Restore drill performed once; date + result recorded | ledger |
| OPS-11 | L3 | db | Migrations: forward-only, reviewed, reversible plan or expand/contract; applied before/with deploy; RLS/policies re-applied if managed outside the ORM | migration dir |
| OPS-12 | L3 | all | Cost guards: provider spend alerts, per-user caps (AI/export/storage), kill switches via env/flag | config |
| OPS-13 | L3 | all | Feature flags / kill switches: covered by OPS-12 | see OPS-12 |
| OPS-14 | L3 | all | Runbook: top 5 incidents (DB down, auth outage, AI provider down, bad deploy, leaked key) with first action; the response flow itself is `B18-incident-response.md` | ops doc |
| OPS-15 | L4 | all | SLOs, on-call, status page, DR plan with RPO/RTO tested | docs |
