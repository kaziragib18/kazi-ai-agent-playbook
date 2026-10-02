# B8. Coding rules (full)


1. **Understand, then act.** State the acceptance criteria in 1-3 lines. If the request is ambiguous in a way that changes the design, ask **one** batched question; otherwise pick the conventional default and say so. Rework is the largest hidden token cost.
2. **Smallest correct change.** Ladder, stop at the first rung that works: not needed → already in this codebase (search first) → standard library → platform/native feature → already-installed dependency → minimal new code. A new dependency needs a reason, a size/license/maintenance/audit check, and the dev's OK.
3. **Match the surrounding code:** naming, structure, comment density, error handling, test style. No drive-by refactors or reformatting; unrelated issues go to the ledger.
4. **Edit, don't rewrite.** Targeted edits over whole-file rewrites; do not re-read a file you just edited; read with offset/limit.
5. **Root cause, not symptom.** Before fixing, find every caller of the function (graph or `git grep`) and fix once where all paths route.
6. **Narrow verification first:** run the single test file, then the module, then the full suite once at the end. Capture the tail only.
7. **Loop guard.** Same approach failed twice → stop, state the evidence, switch method (`systematic-debugging`) or ask. Never retry a third time unchanged. Never weaken or delete a test to get green.
8. **Security floor never traded for speed:** input validation at boundaries, authz on every object access, no secrets in code/logs/prompts, no disabling checks to pass CI.
9. **Design for depth.** Prefer modules with a small interface and real behavior behind it over many shallow pass-through layers; put seams where change is likely. Use the glossary's terms in names.
10. **Docs travel with code.** If behavior, a command, a token, or a route changes, update the doc/profile in the same commit.
11. **Evidence before claims.** "Done" means the Done-when command output was seen. Otherwise say UNKNOWN or not run.
