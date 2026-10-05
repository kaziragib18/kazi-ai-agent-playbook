# Kazi's AI Agent Playbook (Claude Code plugin)

How AI agents plan, build, check and ship any product, with the developer in control.

**Developer briefing (26 pages, for people):** [docs/Kazi's AI Agent Playbook.pdf](<docs/Kazi's AI Agent Playbook.pdf>)

The playbook is a Claude Code skill (`agent-playbook`) that gives an AI coding agent one consistent way of working: agree on what "done" means before touching code, ask before anything risky, prove every claim, and check security, testing, legal, UX, performance, ops, SEO and payments at the level your project actually needs. It works for a brand-new product, a new feature, or a project you are joining halfway through.

## What it does for you

| You want to… | What the agent does |
|---|---|
| **Start a new product** from an empty repo | Interviews you, drafts a one-page product brief and a stack decision for your approval, sets up the repo, ships a thin working version to a preview URL, writes the architecture docs, then builds the rest in small slices, riskiest first. |
| **Build a feature** | Writes a short plan (3-6 lines for small changes, a full spec for bigger ones), waits for your yes, builds it test-first, reviews it with a fresh agent, and opens a PR with the proof attached. |
| **Join an existing project** | Scans the repo, and if there is no product brief or architecture summary, drafts them **from the code** (marked "dev: please correct") so you and the agent work from the same picture. Your `CLAUDE.md` / `AGENTS.md` are never rewritten without asking. |
| **Fix a bug** | Reproduces it with a failing test first, fixes the root cause (every caller, not just the one in the report), and keeps the test. |
| **Check before a release** | Runs every check that applies at your level, records results in a ledger, and reports in plain words: what is fine, what needs fixing (with `file:line` and the fix), what it couldn't check, and the one next step. |
| **Run the product after launch** | Daily first-week review, weekly dependency and spend checks against your budget, and an incident flow when production breaks: contain first (always with your OK), then fix with a test, then a short postmortem. |

## How it works

1. **A small core loads on every task.** `SKILL.md` holds six hard gates, a task router and a one-screen rules card.
2. **The router opens only what the task needs.** A bug fix loads the bug workflow; a release check loads the checklists. Nothing else is read, which keeps token cost low.
3. **Two dials decide which of the 162 checks apply.** The **level** is how strict to be (L1 prototype · L2 free beta with real users · L3 public or paid launch · L4 regulated or at scale). The **flags** say what the project contains (auth, database, AI, payments, uploads…). A free MVP never sees payment or enterprise checks.
4. **Every check is a command, not an opinion.** Most are a single search (`scripts/gg.sh`) with a stated expected result. Unchecked means "couldn't check", never "fine".
5. **State lives in your repo**, so a fresh session continues where the last one stopped: `docs/agent-profile.md` (level, flags, stack, your decisions), `docs/readiness-ledger.md` (check results), the product brief, specs, architecture docs and handoff notes.

**The six gates** (only you can waive one): a "how we'll know it's done" check before any edit · approved brief and stack before new-product code · an approved plan before anything users will notice · ask before installs, pushes, deploys, spending, deleting data or live legal text · evidence before claims · your instructions and your repo's rules beat the playbook.

**Also built in:**
- **Model fit:** at the start of a session the agent tells you, in one line, if the task looks too big or risky for the current model (or small enough for a cheaper one). You decide; it never blocks.
- **Skill picking:** for each capability (planning, TDD, code review, security review, browser checks, docs lookup, dead-code detection…) it uses the first matching skill actually installed, falls back to a built-in method if none is, and asks you once before anything is installed.
- **Teams:** tasks are claimed with an `Owner:` line, each agent works in its own branch or worktree, and the shared files have merge rules.
- **Other stacks:** worked check translations for Python, Go, Rails and Laravel (`references/stack-translations.md`); other stacks are translated once and saved in the profile.
- **Plain language:** the agent talks in everyday words ("fine / needs fixing / couldn't check", "ready for a free beta"). Gate numbers and item IDs stay in the files.

## Install (once per machine)

```bash
claude plugin marketplace add kaziragib18/kazi-ai-agent-playbook
claude plugin install kazi-ai-agent-playbook@kazi-playbook
```

Inside a session the same works with `/plugin marketplace add …` and `/plugin install …`.

Leave out `--scope` (user scope, the default) so the plugin works in every project and updates need no extra flags. Use `--scope project` only if you want it in one repo.

## Turn it on in a project

Add one line to the project's `CLAUDE.md`, so the gates apply to every task and not only when the skill happens to trigger:

> For every task in this repo, use the `agent-playbook` skill: follow its gates, task router and rules card, and ask me before installing anything.

Optional: to offer the plugin to everyone who opens a project, commit the marketplace in that project's `.claude/settings.json` under `extraKnownMarketplaces` and enable the plugin under `enabledPlugins`. Check the current Claude Code settings docs for the exact shape before committing it.

## How to use it

Talk to Claude Code normally; these phrases are the shortcuts:

| Say | What happens |
|---|---|
| **"Start Phase 0"** | Brand-new product: brief and stack decision for your approval, then repo setup. |
| **"Run the preflight"** | First session in an existing repo: scan, proposed level and flags, one batched question, missing docs drafted from the code. |
| *any task*, e.g. "add CSV export" | Plan for your approval (if users will notice it), build, prove, report. |
| **"Run the release check"** (optionally "for a public paid launch") | Every check at your level, ledger updated, plain-language report. |
| **"How did the last check go?"** | The latest results from the ledger, without re-checking. |
| **"Payments are failing"** / "something broke in production" | Severity, the smallest step that stops the harm, and the exact command, for your OK. |
| **"What should I install?"** | The skills worth installing for this product type, and what not to install. |

The skill can also be called directly: `/kazi-ai-agent-playbook:agent-playbook`.

Write tasks with an outcome, how you'll know it's done, and the files in scope; a vague task costs more tokens than a precise one. At L2 and above, turn on a pre-commit hook and required CI so the rules are enforced by tools, not just followed (`references/B12-enforcement.md`).

**You stay in charge of:** the level, approving briefs, plans and stack choices, legal text, outside accounts (hosting, CI, error tracking, payments), every push, deploy and production action, which model you run, and what gets installed.

## Getting updates (teammates)

You never need to uninstall and reinstall. Run both steps (the first refreshes the catalog, the second updates the installed plugin), then restart Claude Code:

```bash
claude plugin marketplace update kazi-playbook
claude plugin update kazi-ai-agent-playbook@kazi-playbook
```

- Installed for one project only (`Scope: project` in `claude plugin list`)? Run the update from inside that project and add `--scope project`. Without it the user scope is updated and the project stays on the old version.
- Check with `claude plugin list`: the version should match the latest `version` in `plugins/kazi-ai-agent-playbook/.claude-plugin/plugin.json` on GitHub.
- Optional: run `/plugin` in Claude Code, open the `kazi-playbook` marketplace and turn on auto-update if your Claude Code version offers it. New versions then arrive on their own and only need a restart.

## What is inside

```
plugins/kazi-ai-agent-playbook/skills/agent-playbook/
  SKILL.md                      core: gates, two dials, task router, rules card, plain-language rules (~2.9k tokens, loaded when the skill triggers)
  references/B1…B18-*.md        playbooks, opened only when the router names them:
                                  quickstart, Phase 0, checks, tokens, asking, ledger, sessions and teams, coding, safety,
                                  build workflow, launch, enforcement, versioning, improving, architecture docs,
                                  joining an existing project, model fit, incident response
  references/skill-registry.md  product type → skills, capability → provider → fallback, skill budget
  references/stack-translations.md   check equivalents for Python, Go, Rails, Laravel
  references/modules/*.md       9 checklists, 162 items (sec, qa, ai, legal, ux, perf, ops, seo, pay)
  assets/profile-template.md    copied to docs/agent-profile.md in each project
  scripts/recon.sh              2-second project fingerprint (stack, flags, routes, tests, missing files)
  scripts/gg.sh                 search helper every check runs through (works with or without git)
```

## Honest limits

- It is advice, not enforcement: the `CLAUDE.md` line plus hooks and CI make it stick.
- Grep checks find missing things well; subtle logic bugs still need tests and review.
- Piloted on a Next.js repo and a plain HTML/JS app. The newest parts (joining existing projects, architecture docs, model fit, incident response, non-JS translations) are not yet piloted on real projects; the translations are tested against sample files only.
- Legal items are drafts; a human, ideally a lawyer, approves anything that goes live.

## Publishing an update (maintainer)

1. Make the change on a branch.
2. **Bump the version** (Claude Code detects updates by this number; if it stays the same, teammates may not get the new files):
   - `version` in `plugins/kazi-ai-agent-playbook/.claude-plugin/plugin.json` (patch `4.3.0 → 4.3.1` for fixes, minor `4.4.0` for new rules or checks, major `5.0.0` when gates or the protocol change)
   - the version in the `SKILL.md` header
3. Add one changelog line at the top of the list in `plugins/kazi-ai-agent-playbook/skills/agent-playbook/references/B13-versioning.md`.
4. If the change affects what developers see or do, update `docs/briefing.html` and re-print the PDF:
   ```bash
   "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --no-pdf-header-footer \
     --print-to-pdf="docs/Kazi's AI Agent Playbook.pdf" "file://$PWD/docs/briefing.html"
   ```
5. Validate: `claude plugin validate .` and `claude plugin validate plugins/kazi-ai-agent-playbook` must both pass.
6. Merge to `main` and push.
7. Tell the team to run the two commands in **Getting updates** and restart (not needed for anyone with auto-update on).
8. Check one machine: `claude plugin list` shows the new version.
