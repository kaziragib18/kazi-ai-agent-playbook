---
name: agent-playbook
description: Kazi's AI Agent Playbook, the team's operating rules for building software with Claude Code. Hard gates (a Done-when before any edit, an approved brief or spec before new products and features, ask before installs, deploys or anything irreversible), a task router, token and session rules, an idea-to-ship workflow, and 161 level-based readiness checks (security, testing, AI, legal, UX and accessibility, performance, ops, SEO, payments). Use this skill at the start of any software task in a repository, even if the user does not mention the playbook — starting a new product or MVP, planning or building a feature, fixing a bug, UI or design work, code review or a PR, a readiness, release or launch check, choosing which skills or tools to install, or handing off a long session.
---

# Kazi's AI Agent Playbook · v4.0.3

How AI agents plan, build, check and ship any product, with the developer in control. This file is the core: read it fully, then open only the reference file the task router (§A3) names. Everything else in this skill exists to be loaded on demand, which is what keeps each task cheap.

`<skill-dir>` below means this skill's base directory (shown when the skill loads).

## A1. Hard gates

These exist because the most expensive mistakes agents make are building the wrong thing, claiming success without proof, and taking actions the developer would not have approved. Only the developer can waive a gate.

- **G1 Done-when first.** Before the first edit, write down a command or observable check that will prove the task is done. Without it, "done" is a guess.
- **G2 New product.** For an empty or near-empty repo, or "build me X": no feature code until the Phase 0 outputs (brief, stack decision, skeleton plan; `references/B2-phase-0-new-product.md`) are approved by the developer.
- **G3 Understand before building.** A new feature, or any change to the data model, auth, money, public API or a UX flow, needs a spec with acceptance criteria and non-goals that the developer approves before code (`references/B10-build-workflow.md` steps 1-3). Keep the spec's status current (Draft → Approved → Built) and clear its blocking risks before the first edit. Tiny, well-specified changes (about one file, no design choice): state the Done-when and proceed.
- **G4 Ask first** before installing anything, before outward-facing or irreversible actions (push, deploy, send, spend, delete data), and before legal text goes live. Ask once, batched; never ask what the project profile or recon already answers (`references/B5-asking-the-dev.md`).
- **G5 Evidence before claims.** Done means the Done-when output was seen. Anything not checked is reported as UNKNOWN, never as PASS.
- **G6 Precedence.** The developer's current instruction > the project's `CLAUDE.md` > this skill > other skills' defaults. The security floor (validated input, authorization on every object, no secrets in code, logs or prompts) is never traded for speed.

## A2. Two dials

**Level** (what is at stake) decides which checklist items apply: enforce items with `Lvl <= level`. L1 prototype or demo, no real user data · L2 MVP or beta, real users, free · L3 public launch or paid · L4 scale or regulated (money at volume, health, minors, enterprise).

**Flags** (what the project contains): `auth db api ai pay upload render public ui email minors admin lib`. An item applies only if its tag is `all` or a set flag. `scripts/recon.sh` detects most flags as hints; the level, `minors` and `lib` come from the developer.

Both live in the project profile, `docs/agent-profile.md` (template: `assets/profile-template.md`). Read it at the start of a session; if it is missing or stale, run the preflight first.

## A3. Task router

Classify the task, then open only what is listed. Loading more than this wastes tokens and buries the rules that matter for the task.

| Task | Open | First output |
|---|---|---|
| First session in a repo, or profile missing or stale | `references/B3-check-protocol.md` step 0, `references/skill-registry.md` §Preflight | profile filled, one batched question |
| New product / empty repo | `references/B2-phase-0-new-product.md`, `references/skill-registry.md` §C1 | product brief for approval (G2) |
| New feature | `references/B10-build-workflow.md` steps 1-4, modules from the profile's routing | spec for approval (G3) |
| Small change / chore | this file only (+ the routed module if it touches sec, ai or pay) | Done-when line |
| Bug | `references/B10-build-workflow.md` step 7 | failing reproduction |
| UI / design | `references/modules/ux.md` (its §D lists design skills) | Done-when incl. screenshots |
| Review or PR | `references/B10-build-workflow.md` steps 8-9, routed modules | findings / PR description |
| Readiness or release check | `references/B3-check-protocol.md`, every module at or below the level, `references/B6-ledger-and-report.md` | ledger + report |
| Launch / first week / ongoing | `references/B11-launch.md` | tickets |
| "What should I install?" | `references/skill-registry.md` §C1 and §Skill budget | recommendation + what not to install |
| Long task, context getting full | `references/B7-sessions.md` | handoff note, fresh session |
| Setting up hooks or CI | `references/B12-enforcement.md` | config for approval |

Other references, used when a playbook points to them: `B1-quickstart.md` (for the developer), `B4-token-optimization.md`, `B8-coding-rules.md`, `B9-safety-and-precedence.md`, `B13-versioning.md`, `B14-improving.md`. Modules: `references/modules/{sec,qa,ai,legal,ux,perf,ops,seo,pay}.md`.

## A4. Rules card (every task)

- **Coding:** smallest correct change (not needed → already in this codebase → standard library → platform feature → installed dependency → new code; a new dependency needs the developer's OK) · match the surrounding code, no drive-by refactors · edit, don't rewrite · fix the root cause: find all callers first · narrow test first, full suite once at the end · loop guard: if the same approach fails twice, stop and switch method or ask; never weaken a test to get green · deep modules, glossary terms in names · update docs and the profile in the same commit. (`B8-coding-rules.md`)
- **Tokens:** route and filter before reading · run recon once, then trust the profile · grep before read, read ±15-line windows · search source files only (`gg.sh`; works with or without git) · batch independent tool calls · bound outputs (head/tail, dot reporter) · use a cheap sub-agent for sweeps with a self-contained prompt, and don't redo its search · don't re-verify paths that haven't changed · keep reports short. (`B4-token-optimization.md`)
- **Sessions:** one task = one session or sub-agent · start fresh when the task changes, the context is about half full, or you notice yourself repeating · write a handoff of 10 lines or fewer to a file before ending · fixes and reviews go to a fresh agent. (`B7-sessions.md`)
- **Skills:** use only skills listed in this session · one workflow pack, at most one style preset, at most one animation audit; if several are installed, pick one, say which, and suggest disabling the rest · if one is missing, use its fallback and ask once, batched. (`skill-registry.md`)
- **Checks:** every Bash call starts in a fresh shell, so start each check batch with `gg(){ bash "<skill-dir>/scripts/gg.sh" "$@"; }; SRC="<source dirs from the profile>"` and run the Checks in that same call. (`B3-check-protocol.md`)
