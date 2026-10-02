# B3. Check protocol (preflight → route → filter → verify → fix → prove → report)


0. **Preflight (once per session, <= 3 tool calls)**
   - Read the project profile (`docs/agent-profile.md`). Trust it (no re-recon) if `git diff --name-only <the project profile (`docs/agent-profile.md`) commit>..HEAD -- package.json pyproject.toml go.mod '*lock*' '*.config.*' .github` is empty and no new top-level source dir appeared. If the profile's `commit:` is `none` but the repo now has commits, it is stale: re-run recon and record the commit. **Not a git repo:** trust it unless `find . -maxdepth 2 \( -name package.json -o -name pyproject.toml -o -name go.mod -o -name '*lock*' -o -name '*.config.*' \) -newer docs/agent-profile.md` prints something. Otherwise re-run recon and update the project profile (`docs/agent-profile.md`).
   - Else run `bash <skill-dir>/scripts/recon.sh` (the skill's base directory is shown when the skill loads). Fill the project profile (`docs/agent-profile.md`) flags. If **level** is unknown, ask the dev (one question, §B5).
   - Read `references/skill-registry.md` §Preflight: resolve the skills you need against the skills actually listed in this session. Ask about missing ones **once, batched** (§B5).
1. **Route.** `git diff --name-only <base>...HEAD`, or the files the task names; without git, files changed since the last ledger entry (`find . -type f -newer docs/readiness-ledger.md -not -path '*/node_modules/*'`) → module via the routing table in the project profile (`docs/agent-profile.md`). Release candidate → all items with `Lvl <= level` and nothing else.
2. **Filter.** Keep items where `Lvl <= level` AND tag is `all` or a set flag. Everything else is N/A. Do not discuss N/A items.
3. **Verify.** Every Bash call starts in a fresh shell (functions and variables do not persist), so begin **each** check batch with:
   ```bash
   gg(){ bash "<skill-dir>/scripts/gg.sh" "$@"; }; SRC="<source dirs from the project profile>"
   ```
   then run the Checks exactly as written, in the same Bash call. Tables escape `|` as `\|` (markdown). `gg` converts it back, so Checks can be copied verbatim. In any **non-`gg`** command, replace `\|` with `|` yourself. Never pipe into `gg` (`git grep` ignores stdin); filter with `| grep -iE` instead.
   Substitute placeholders (`<handler files>`, `<url>`) from recon/the project profile (`docs/agent-profile.md`). A Check that is prose only ("manual", "docs", "dev confirms") gives **UNKNOWN** unless you find `file:line` evidence. Never PASS from memory.
   Checks tagged `[js]`/`[next]` are stack-bound: translate once to this stack's equivalent and record the translation in the project profile (`docs/agent-profile.md`), or mark N/A.
   One batched run per module. Stop at first decisive evidence. Result is `PASS | FAIL | N/A | UNKNOWN` + `file:line`. Subtract the project profile (`docs/agent-profile.md`) *Accepted exceptions* before reporting.
4. **Fix** only FAILs inside the task's scope and at or below the current level. Everything else goes to the ledger, not into the diff.
5. **Prove.** Re-run the Check that failed plus the project's test/lint/typecheck commands. No success claims without output (use `superpowers:verification-before-completion` if available).
6. **Report** in the format in §B6. No recap of passes.

**Never do:** web research on standards (OWASP, WCAG, GDPR are encoded in the checks); hardcode directory names (use recon output: repos differ: `components/` may not exist); run the full checklist on a small diff; install anything without approval (§B5); mark a check PASS from memory.
