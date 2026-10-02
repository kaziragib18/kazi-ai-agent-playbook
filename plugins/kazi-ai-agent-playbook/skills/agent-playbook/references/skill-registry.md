# Skill, MCP and tool registry

**Names below are examples seen in real sessions. The session's own skill list is the only source of truth.** Never call a skill because it is in this table; call it because it is listed in the session.

## C1. Product type → modules → skills to propose

At preflight the agent proposes the row that matches the brief or profile, compares it with the skills installed in this session, and asks once (`references/skill-registry.md` §Missing). Names are examples; any skill with the same capability counts.

| Product type | Typical flags · level | Modules | Propose (capabilities) |
|---|---|---|---|
| Any new product (Phase 0) | from the brief | per the row below | one workflow pack (align, spec, slice, TDD, debug, review) · `code-review` |
| Landing / marketing site | ui public · L2-L3 | ux seo perf legal(01,09) sec(50) | design-quality skill · ONE style preset · animation audit only if motion is a goal · browser MCP |
| Frontend app (SPA, consumes an API) | ui api · L2 | ux qa perf sec(30-39) | design-quality skill · browser MCP · TDD |
| MVP SaaS (free) | ui auth db api · L2 | sec qa ux ops(01,02,03,05) legal(01-03) | workflow pack · `security-review` · browser MCP · docs MCP |
| Paid SaaS | + pay email · L3 | all | + payment-provider docs · security review on every money PR |
| AI-powered app | + ai · L2-L3 | + ai | AI API/SDK skill (e.g. `claude-api`) · golden-set evals via TDD |
| API / backend service | api db auth · L2-L3 | sec qa perf ops | TDD · `security-review` · code-graph MCP for large codebases |
| Internal tool | auth db ui · L2 | sec qa ux | workflow pack (skip style presets) |
| Library / package | lib · L2-L3 | qa(01-03,07) sec(51,52) ops(01,02) | TDD · `code-review` · docs-writing skill |

## Preflight (once, no research)

1. List what exists: skills = the "available skills" list in the session context; MCP/tools = names in the tool list; deferred tools via the tool-search feature (Claude Code: `ToolSearch`); CLIs via `command -v gh vercel supabase pnpm npx rg`.
2. For each **capability** in the table below that the routed modules need, find the first available provider. Capabilities with no provider are *missing*.
3. **Check for overlap.** Count installed skills in each pick-one group: workflow packs, style presets (taste, minimalist, premium, brutalist, …), animation audits. If a group has more than one, pick one for this project (match the brief's look, or the one already used), record it in the profile's *Decisions*, and add one line to the batched question: "N style presets are installed; I'm using X. The others load into every session; consider disabling them." Never uninstall anything yourself.
4. Print one line per missing capability; ask once (§B5), together with any overlap line. Proceed with the fallback meanwhile for everything else.

## Capability → provider → fallback

Design, animation, prototype and UI-library rows live in `references/modules/ux.md` §D (loaded only for UI work).

| Capability (needed by) | Preferred provider (examples) | Fallback if missing | Install / access (tell the dev; never run it yourself) |
|---|---|---|---|
| Plan before building (any feature) | `superpowers:brainstorming`, `superpowers:writing-plans` | Write a 10-line plan in chat, get a yes | plugin marketplace |
| Test-first, debugging, completion proof | `superpowers:test-driven-development`, `systematic-debugging`, `verification-before-completion` | Write failing test → fix → run project test script and quote output | plugin marketplace |
| Alignment / interview before building | `grill-me`, `grill-with-docs`, `superpowers:brainstorming` | §B10 step 1 fallback | plugin |
| Spec, slicing into tickets | `to-spec`/`to-prd`, `to-tickets`/`to-issues`, `superpowers:writing-plans` | §B10 steps 3-4 templates | plugin |
| Domain glossary | `domain-modeling` | Hand-written `docs/GLOSSARY.md` | plugin |
| Session handoff | `handoff` | §B7 handoff note | plugin |
| Architecture deepening survey | `improve-codebase-architecture`, `codebase-design` | §B10 step 10 by hand | plugin |
| Post-session retro | `retro` | §B10 step 11 by hand | plugin |
| Cited research on a product/tech question | `research` | Primary sources only, saved as cited markdown in `docs/research/` | plugin |
| Diff correctness review | `code-review` | Read the diff once, check against `references/modules/qa.md` | built-in / plugin |
| Security review of a diff | `security-review` | `references/modules/sec.md` checks via grep | built-in |
| Simplify / bloat | `simplify`, `ponytail:ponytail-review`, `ponytail-audit` | Manual "can this be deleted?" pass on the diff | plugin |
| Code-graph (callers, gating, architecture) | `codebase-memory` MCP (`search_graph`, `trace_path`) | `gg` + 15-line reads | `claude mcp add ...` then index the repo |
| Library docs | `context7` MCP | Read the installed package's bundled docs/README for the exact version; say "unverified" if none | `claude mcp add` / plugin |
| Broad file sweeps | `Explore` agent (small model) | Do the grep batch yourself | built-in |
| Real-browser checks (screenshots, resize, a11y tree, console, network, offline) | Playwright MCP (it blocks `file:` URLs: serve the folder on localhost, e.g. `python3 -m http.server 8765 --bind 127.0.0.1` or the dev server; stop it afterwards and delete `.playwright-mcp/` artifacts) | `npx playwright` script, else mark UI items UNKNOWN | plugin / `claude mcp add playwright` |
| Complete files, no "…rest unchanged" gaps | `full-output-enforcement` / `output-skill` | Instruction: write whole files or use exact-match edits; never placeholders | plugin |
| Claude/Anthropic API code | `claude-api` | Read the provider's current docs for exact model IDs/params; flag unverified | built-in |
| Docs / reports for humans | Artifact tool, `anthropic-skills:docs/pdf/docx/xlsx/pptx` | Markdown file | built-in |
| Permissions, hooks, env config | `update-config`, `fewer-permission-prompts` | Tell dev the setting to change | built-in |
| Recurring checks | `loop`, `CronCreate` | Tell dev to add a CI schedule | built-in |
| Source control / CI | `gh` CLI | Give dev the commands | `brew install gh` |
| Hosting | `vercel` / `netlify` / `fly` CLI or MCP | Describe dashboard steps | CLI install |
| Error tracking / logs | Sentry (or similar) MCP/SDK | Structured console JSON + dev to create account | account + DSN from dev |
| Dependency/secret scan | `pnpm audit`/`npm audit`/`pip-audit`, `gitleaks`, CodeQL | Grep patterns in `references/modules/sec.md` | CLI install or GitHub setting |
| Perf audit | `npx lighthouse` | bundler stats / bundle analyzer + manual CWV note | npx (needs network, ask) |
| Accessibility scan | `axe-core` via Playwright | Keyboard walk + `browser_snapshot` review | npm package |

## Missing (what to ask)

One batched question. Per item write exactly:

```
<capability>: <provider name> not installed.
Unlocks: <one line>.  Without it I will: <fallback>.
To install (you run it): <command or "authorize in claude.ai connector settings">.
Choose: [I'll install it, wait] [Use fallback] [Skip this area]
```

Rules: ask only for capabilities the **routed** modules need; max 4 per prompt (rest in a text list); treat an unanswered question as "use fallback"; remember the answer in the project profile (`docs/agent-profile.md`) Decisions; if the dev later installs a provider, switch to it without asking.

Installation facts you may quote (verify with the dev's tooling): Claude Code plugins: `/plugin marketplace add <owner/repo>` then `/plugin install <plugin>@<marketplace>`; MCP servers: `claude mcp add <name> -- <command>` or manage via `/mcp`; skills are folders with `SKILL.md` under `~/.claude/skills/` (personal) or `.claude/skills/` (project, checked in). Do not invent repo URLs; ask the dev for the source.

## Skill budget (installed skills cost tokens in every session)

Each installed skill's name and description is loaded into context at session start, used or not. A long list also makes the agent pick the wrong one. So:

- **Core set (recommended):** ONE workflow/process pack (e.g. `superpowers` *or* `mattpocock/skills`, not both: they overlap on align, plan, TDD, debug, review) · `code-review` · `security-review` · ONE design-quality skill (e.g. `impeccable`) · a browser MCP · a code-graph MCP and a docs MCP if the stack is large or fast-moving.
- **At most ONE style preset per project** (taste / minimalist / soft-premium / brutalist / Apple-style). They conflict; stacking gives muddled design. Choose by brand, not by novelty.
- **At most ONE animation audit skill.** Vocabulary and polish skills only when the dev wants that depth.
- **Task-scoped skills** (`prototype`, `pick-ui-library`, brand/logo, slides, market research, video/motion graphics): install for the task, suggest removing afterwards.
- Never recommend installing a skill whose capability is already covered by an installed one.
- Never install anything yourself; ask (§B5) with the exact name, what it unlocks and what you will do without it. When the dev asks "what should I install?", answer with the core set above plus only the style/animation skills the project's flags justify, and list what you would **not** install and why.
- The design system (tokens + existing components) outranks any style skill. If a skill's advice conflicts with the project's tokens, the tokens win.

## Picking among overlapping skills

One design/taste skill per task, never stacked. Process skills (brainstorm, plan, TDD, debug) before domain skills. If two providers cover a capability, use the one already used earlier in the session to keep context stable.
