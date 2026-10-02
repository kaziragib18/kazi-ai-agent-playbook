# Kazi's AI Agent Playbook (Claude Code plugin)

How AI agents plan, build, check and ship any product, with the developer in control.

## Install (once per machine)

```bash
claude plugin marketplace add kaziragib18/kazi-ai-agent-playbook
claude plugin install kazi-ai-agent-playbook@kazi-playbook
```

Inside a session the same works with `/plugin marketplace add …` and `/plugin install …`. Get updates (both steps; the first only refreshes the catalog, the second updates the installed plugin), then restart Claude Code:

```bash
claude plugin marketplace update kazi-playbook
claude plugin update kazi-ai-agent-playbook@kazi-playbook
```

Check with `claude plugin list`; the version shown should match `plugins/kazi-ai-agent-playbook/.claude-plugin/plugin.json`.

## Turn it on in a project

Add one line to the project's `CLAUDE.md`, so the gates apply to every task and not only when the skill happens to trigger:

> For every task in this repo, use the `agent-playbook` skill: follow its gates, task router and rules card, and ask me before installing anything.

Then in Claude Code say **"Run the preflight"** (existing repo) or **"Start Phase 0"** (new product). The skill can also be called directly: `/kazi-ai-agent-playbook:agent-playbook`.

Optional: to offer the plugin to everyone who opens a project, commit the marketplace in that project's `.claude/settings.json` under `extraKnownMarketplaces` and enable the plugin under `enabledPlugins`. Check the current Claude Code settings docs for the exact shape before committing it.

## What is inside

```
plugins/kazi-ai-agent-playbook/skills/agent-playbook/
  SKILL.md                 core: gates, two dials, task router, rules card (always loaded when the skill triggers)
  references/B1…B14-*.md   playbooks, opened only when the router names them
  references/skill-registry.md
  references/modules/*.md  9 checklists, 161 items
  assets/profile-template.md   copied to docs/agent-profile.md in each project
  scripts/recon.sh         2-second project fingerprint
  scripts/gg.sh            grep helper the checks use
```

## Changing it

Edit files, bump `version` in `plugins/kazi-ai-agent-playbook/.claude-plugin/plugin.json` and the SKILL.md header, add a changelog line in `references/B13-versioning.md`, then run `claude plugin validate .` and open a PR.
