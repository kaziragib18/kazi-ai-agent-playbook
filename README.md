# Kazi's AI Agent Playbook (Claude Code plugin)

How AI agents plan, build, check and ship any product, with the developer in control.

## Install (once per machine)

```bash
claude plugin marketplace add kaziragib18/kazi-ai-agent-playbook
claude plugin install kazi-ai-agent-playbook@kazi-playbook
```

Inside a session the same works with `/plugin marketplace add …` and `/plugin install …`.

Leave out `--scope` (user scope, the default) so the plugin works in every project and updates need no extra flags. Use `--scope project` only if you want it in one repo.

## Getting updates (teammates)

You never need to uninstall and reinstall. Run both steps (the first refreshes the catalog, the second updates the installed plugin), then restart Claude Code:

```bash
claude plugin marketplace update kazi-playbook
claude plugin update kazi-ai-agent-playbook@kazi-playbook
```

- Installed for one project only (`Scope: project` in `claude plugin list`)? Run the update from inside that project and add `--scope project`. Without it the user scope is updated and the project stays on the old version.
- Check with `claude plugin list`: the version should match the latest `version` in `plugins/kazi-ai-agent-playbook/.claude-plugin/plugin.json` on GitHub.
- Optional: run `/plugin` in Claude Code, open the `kazi-playbook` marketplace and turn on auto-update if your Claude Code version offers it. New versions then arrive on their own and only need a restart.

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

## Publishing an update (maintainer)

1. Make the change on a branch.
2. **Bump the version** (Claude Code detects updates by this number; if it stays the same, teammates may not get the new files):
   - `version` in `plugins/kazi-ai-agent-playbook/.claude-plugin/plugin.json` (patch `4.0.3 → 4.0.4` for fixes, minor `4.1.0` for new rules or checks, major `5.0.0` when gates or the protocol change)
   - the version in the `SKILL.md` header
3. Add one changelog line at the top of the list in `plugins/kazi-ai-agent-playbook/skills/agent-playbook/references/B13-versioning.md`.
4. Validate: `claude plugin validate .` and `claude plugin validate plugins/kazi-ai-agent-playbook` must both pass.
5. Merge to `main` and push.
6. Tell the team to run the two commands in **Getting updates** and restart (not needed for anyone with auto-update on).
7. Check one machine: `claude plugin list` shows the new version.
