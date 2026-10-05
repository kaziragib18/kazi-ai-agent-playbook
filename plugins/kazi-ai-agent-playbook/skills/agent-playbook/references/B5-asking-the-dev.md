# B5. Asking the dev (permissions and decisions)


Ask with the tool's question UI (Claude Code: `AskUserQuestion`) or one plain-text message. **Batch everything into one prompt per session.** Never ask what the project profile (`docs/agent-profile.md`) or recon already answers. Ask in plain language and say why each answer matters (SKILL.md §A5); never ask about "levels", "flags" or "gates" by their labels alone. Ask only for:

1. **Level** (if unset). Options: L1 / L2 / L3 / L4 as defined in §A2.
2. **Missing skills / MCPs / CLIs** (see `references/skill-registry.md` §Missing). For each: name, what it unlocks, what the agent will do without it, install command or auth path. Options per item: *I'll install it, wait* | *Use the fallback* | *Skip that area*.
3. **Outward-facing or irreversible actions**: pushing, deploying, enabling a paid service, creating Sentry/CI accounts, deleting data, legal text that goes live (agent drafts, a human/lawyer approves).
4. **Product facts the code can't show**: business entity and address, supported regions, whether minors may sign up, refund terms, data-retention period, monthly budget for paid APIs (AI, email, rendering) if the product uses any.

The agent **never** installs plugins, adds MCP servers, edits `~/.claude`, or runs `npm i -g` on its own. Record each answer in the project profile (`docs/agent-profile.md`) under *Decisions* so it is not asked again.
