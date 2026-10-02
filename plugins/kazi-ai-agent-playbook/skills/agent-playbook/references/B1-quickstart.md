# B1. Developer quickstart (2 minutes, once per project)

1. Install the plugin once per machine (see the plugin repo README): `/plugin marketplace add <team-repo>` then `/plugin install kazi-ai-agent-playbook@<marketplace>`.
2. Add one line to each project's `CLAUDE.md` so the gates apply to every task, not only when the skill happens to trigger:
   > For every task in this repo, use the `agent-playbook` skill: follow its gates, task router and rules card, and ask me before installing anything.
3. First session: say **"Run the preflight."** For a brand-new product say **"Start Phase 0"** instead (§B2). The agent runs recon, proposes flags and a level, and asks the few questions it cannot answer in one batch.
4. Answer once. Answers go into the project profile (`docs/agent-profile.md`), so they are never asked again.
5. Write each task with an outcome, a Done-when and the files in scope (§B7 template). A vague task costs more tokens than a long precise one.
6. For a release: **"Run the release check at level L3."** You get counts, failures with `file:line`, and one next action.
7. At L2+, make the rules binding: pre-commit hook + CI required on the default branch (§B12).
8. Updates arrive through the plugin; see §B13 for versioning.

**You own:** the level, approval of briefs and specs (gates G2/G3), legal text, accounts for outside services (hosting, CI, error tracking, payments), deploys, and permission to install skills.
