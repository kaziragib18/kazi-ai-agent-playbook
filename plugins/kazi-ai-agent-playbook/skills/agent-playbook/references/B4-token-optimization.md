# B4. Token optimization (ranked by savings)


| # | Rule | How |
|---|---|---|
| 1 | Progressive disclosure | Guide first, modules only when routed, profile instead of re-exploring. Never load all modules. |
| 2 | Fingerprint once | recon replaces ~10-20 exploratory calls. Cache result in the project profile (`docs/agent-profile.md`). |
| 3 | Filter before reading | Level + flag + changed-path filters usually remove 70-90% of items. |
| 4 | Grep before Read | `gg -l`, `gg -c`, `gg` with patterns from the Check; read only a +/-15-line window (`Read` with `offset`/`limit`). Never read a file to "understand" it for a check. |
| 5 | Search source files only | `gg` lets git list the files in a repo (tracked and untracked, `.gitignore` respected) and greps them; without git it uses `grep -r` with dependency/build/cache folders excluded. Skips `node_modules`, build output, generated code and **`.claude/worktrees` copies** (these double-count matches). |
| 6 | Graph over files | If a code-graph MCP is present, `search_graph` / `trace_path` answers "who calls / is this gated" without reading files. |
| 7 | Delegate sweeps | Cross-cutting module (3+ files, e.g. "every route authenticates") → one sub-agent on the **cheapest model that can grep** (Claude Code: `Explore` agent, `model: haiku`; other tools: their cheaper sub-agent/model, or run the batch yourself), instruction: "return one line per item as id, PASS/FAIL, file:line; max 15 lines". Run independent modules in parallel in one message. Give the subagent a self-contained prompt (goal, paths, output format); do not repeat its search yourself; never ask a sweep subagent to fix. |
| 8 | Docs on demand | Library API uncertainty → docs MCP (e.g. context7) for that one symbol. Never paste whole docs. |
| 9 | Batch tool calls | Independent greps in one parallel block; chain dependent ones with `&&`. |
| 10 | Bound outputs | `head -20`, `-m 3`, `wc -l` first. Do not `cat` lockfiles, generated code, minified files, or full test output (use `--reporter=dot` / tail 30). |
| 11 | Stable prefix | Keep guide text unchanged between sessions so prompt caching hits. Volatile data (ledger, diff) goes after it. |
| 12 | Short outputs | Ledger line + counts. The dev can ask for detail. |
| 13 | Don't re-verify | Skip an item whose latest ledger date is newer than `git log -1 --format=%cs -- <its paths>`. Without git, compare the paths' modification dates (`find <paths> -newer docs/readiness-ledger.md`). |
| 14 | Plan once for big remediation | >5 FAILs: `writing-plans` once, then one fresh subagent per task with a file handoff. Don't fix inline in a bloated context. See §B7. |

**Model choice (sub-agents/delegated work):** greps, sweeps, formatting → small model. Security-sensitive fixes, architecture decisions, ambiguous failures → the strong model. Never use a small model to judge an auth or payment fix. For the primary session's own model (what the dev is talking to), see `B17-model-fit.md` — checked once per fresh session before the first edit, as a recommendation, never a block.
