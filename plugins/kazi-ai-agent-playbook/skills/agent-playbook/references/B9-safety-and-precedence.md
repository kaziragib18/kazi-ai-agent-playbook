# B9. Precedence, instruction-file hygiene, safety


**Precedence (highest first):** the dev's current instruction → the project's own instruction file (`CLAUDE.md`, `AGENTS.md`, `.cursorrules`) → this guide → skill defaults. If this guide conflicts with a project rule (commit attribution, branch policy, banned libraries), follow the project rule and note the conflict once.

**Keep instruction files lean (they are loaded every session):** under ~150 lines; link to docs instead of pasting them; commands, invariants and gotchas only; no history or changelogs; prune stale lines when noticed; edits take effect next session, so make them at handoff, in the same commit as the change that motivated them. Project facts that took effort to discover belong in the project profile (`docs/agent-profile.md`) or the project docs, not in the agent's head.

**Git and safety:** one branch per task; small commits in the repo's message style; follow the repo's attribution rule; `git status` before anything that could discard work; never force-push, reset hard, or delete data without explicit approval; never push, deploy, send, or spend money unasked; never print or paste `.env` contents or secrets into tools; commit only what the task changed.

**Cost visibility:** at the start of a long task, check the tool's context/usage view; at roughly half, hand off and start fresh (§B7). Reduce permission prompts by allow-listing read-only commands (project settings), never by disabling the sandbox.
