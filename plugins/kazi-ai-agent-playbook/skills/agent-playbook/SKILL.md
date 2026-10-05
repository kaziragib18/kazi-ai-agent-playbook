---
name: agent-playbook
description: Kazi's AI Agent Playbook, the team's operating rules for building software with Claude Code: hard gates, a task router and level-based readiness checks. Use this skill at the start of any software task in a repository, even if the user does not mention the playbook — starting a new product or MVP, planning or building a feature, fixing a bug, UI or design work, joining an existing or unfamiliar codebase, code review or a PR, a readiness, release or launch check, a production incident, choosing which skills or tools to install, or handing off a long session.
---

# Kazi's AI Agent Playbook · v4.3.3

How AI agents plan, build, check and ship any product, with the developer in control. This file is the core: read it fully, then open only the reference file the task router (§A3) names. Everything else in this skill exists to be loaded on demand, which is what keeps each task cheap.

`<skill-dir>` below means this skill's base directory (shown when the skill loads).

## A1. Hard gates

These exist because the most expensive mistakes agents make are building the wrong thing, claiming success without proof, and taking actions the developer would not have approved. Only the developer can waive a gate.

- **G1 Done-when first.** Before the first edit, write down a command or observable check that will prove the task is done. Without it, "done" is a guess.
- **G2 New product.** For an empty or near-empty repo, or "build me X": no feature code until the Phase 0 outputs (brief, stack decision, skeleton plan; `references/B2-phase-0-new-product.md`) are approved by the developer.
- **G3 Agree before building anything users will notice.** Decide by what changes for the user, not by how small the diff is. Anything that adds or changes what a user sees or can do (a new button, option, sort, filter, field, page, message or flow), or touches the data model, auth, money or a public API, needs a short plan the developer approves before the first edit. For a small feature the plan is 3-6 lines in chat: what will change, how you'll both know it works, what you won't do; write it to `docs/specs/` after approval. Bigger features get the full spec (`references/B10-build-workflow.md` steps 1-3). Only changes with no visible effect skip this (a refactor, a typo, a dependency bump, restoring behavior that was already agreed): say how you'll know it's done and proceed. Keep the spec's status current (Draft → Approved → Built) and clear its blocking risks before the first edit.
- **G4 Ask first** before installing anything, before outward-facing or irreversible actions (push, deploy, send, spend, delete data), and before legal text goes live. Ask once, batched; never ask what the project profile or recon already answers (`references/B5-asking-the-dev.md`).
- **G5 Evidence before claims.** Done means the Done-when output was seen. Anything not checked is reported as UNKNOWN, never as PASS. Never call a plan or spec "approved" unless its `**Status:**` line says Approved or the developer approved it in this session.
- **G6 Precedence.** The developer's current instruction > the project's `CLAUDE.md` > this skill > other skills' defaults. The security floor (validated input, authorization on every object, no secrets in code, logs or prompts) is never traded for speed.

## A2. Two dials

**Level** (what is at stake) decides which checklist items apply: enforce items with `Lvl <= level`. L1 prototype or demo, no real user data · L2 MVP or beta, real users, free · L3 public launch or paid · L4 scale or regulated (money at volume, health, minors, enterprise).

**Flags** (what the project contains): `auth db api ai pay upload render public ui email minors admin lib`. An item applies only if its tag is `all` or a set flag. `scripts/recon.sh` detects most flags as hints; the level, `minors` and `lib` come from the developer.

Both live in the project profile, `docs/agent-profile.md` (template: `assets/profile-template.md`). Read it at the start of a session; if it is missing or stale, run the preflight first. If project files disagree (e.g. brief vs profile), the **profile wins** for level, flags and decisions, the **brief** for product scope; mention the mismatch once in plain words and fix the stale file after the developer confirms.

## A3. Task router

Classify the task, then open only what is listed (silently: never tell the developer which files you opened; see §A5). Loading more than this wastes tokens and buries the rules that matter for the task.

**Setup comes first.** Before the task's own row: if `docs/agent-profile.md` is missing or stale, run the first row; if the repo is not empty but has no product brief or architecture summary, run the existing-repo row. For a tiny task, instead say in one line what is missing and offer to draft it, then do the task.

| Task | Open | First output |
|---|---|---|
| First session in a repo, or profile missing or stale | `references/B3-check-protocol.md` step 0, `references/skill-registry.md` §Preflight | profile filled, one batched question |
| Existing (non-empty) repo missing product or architecture docs | `references/B16-mid-project-onboarding.md` | one-line note on what's being drafted, then the actual task |
| New product / empty repo | `references/B2-phase-0-new-product.md`, `references/skill-registry.md` §C1 | product brief for approval (G2) |
| New feature | `references/B10-build-workflow.md` steps 1-4, modules from the profile's routing; check the brief's out-of-scope list first | out-of-scope note if it applies, then spec for approval (G3) |
| Small change with **no visible effect** (refactor, typo, dependency bump, restoring agreed behavior) | this file only (+ the routed module if it touches sec, ai or pay) | how you'll know it's done |
| Small feature (any visible change, however small) | this file (§A1 G3); first read the "Won'ts" / out-of-scope list in `docs/PRODUCT-BRIEF.md` if it exists | if the request is out of scope, send **only** that question and stop: "Your product brief lists X as out of scope, so adding it means updating the brief. Do you want that?" (no plan yet; plan after a yes). Otherwise a 3-6 line plan for approval |
| Bug | `references/B10-build-workflow.md` step 7 | failing reproduction |
| UI / design | `references/modules/ux.md` (its §D lists design skills) | Done-when incl. screenshots |
| Review or PR | `references/B10-build-workflow.md` steps 8-9, routed modules | findings / PR description |
| Readiness or release check | `references/B3-check-protocol.md`, every module at or below the level, `references/B6-ledger-and-report.md` | ledger + report |
| "How did the last check go?" (no new check asked for) | `references/B6-ledger-and-report.md` | the latest run block of the ledger, reported in words; no re-checking |
| Launch / first week / ongoing | `references/B11-launch.md` | tickets |
| Something broke in production (errors spiking, core flow or payments down, bad deploy, leaked key) | `references/B18-incident-response.md` | severity + the proposed containment step, for approval |
| "What should I install?" | `references/skill-registry.md` §C1 and §Skill budget | recommendation + what not to install |
| Long task, context getting full | `references/B7-sessions.md` | handoff note, fresh session |
| Setting up hooks or CI | `references/B12-enforcement.md` | config for approval |

Modules live in `references/modules/{sec,qa,ai,legal,ux,perf,ops,seo,pay}.md`; every other reference is opened only when a playbook names it.

## A4. Rules card (every task)

- **Coding:** smallest correct change (not needed → already in this codebase → standard library → platform feature → installed dependency → new code; a new dependency needs the developer's OK) · match the surrounding code, no drive-by refactors · edit, don't rewrite · fix the root cause: find all callers first · narrow test first, full suite once at the end · loop guard: if the same approach fails twice, stop and switch method or ask; never weaken a test to get green · deep modules, glossary terms in names · update docs and the profile in the same commit, including `ARCHITECTURE-ESSENTIALS.md` whenever the change touches an invariant (`B15-architecture-docs.md`). (`B8-coding-rules.md`)
- **Tokens:** route and filter before reading · run recon once, then trust the profile · grep before read, read ±15-line windows · search source files only (`gg.sh`; works with or without git) · batch independent tool calls · bound outputs (head/tail, dot reporter) · use a cheap sub-agent for sweeps with a self-contained prompt, and don't redo its search · don't re-verify paths that haven't changed · keep reports short. (`B4-token-optimization.md`)
- **Sessions:** one task = one session or sub-agent · start fresh when the task changes, the context is about half full, or you notice yourself repeating · write a handoff of 10 lines or fewer to a file before ending · fixes and reviews go to a fresh agent. (`B7-sessions.md`)
- **Skills:** use only skills listed in this session · one workflow pack, at most one style preset, at most one animation audit; if several are installed, pick one, say which, and suggest disabling the rest · if one is missing, use its fallback and ask once, batched. (`skill-registry.md`)
- **Checks:** every Bash call starts in a fresh shell, so start each check batch with `gg(){ bash "<skill-dir>/scripts/gg.sh" "$@"; }; SRC="<source dirs from the profile>"` and run the Checks in that same call. (`B3-check-protocol.md`)

## A5. Talking to the developer (plain language, always)

Most developers will never read this playbook. Everything you say must make sense to someone who has not, or the playbook becomes friction instead of help. The labels in this skill (gate numbers like G3, section numbers like B10, module names like `sec`, item IDs like UX-04, ranges like `sec(10-19)`, "routed", "level L2") are for your own navigation.

- **In chat, never use those labels on their own.** Say what you are doing and why, in everyday words. Keep routing and file-loading silent; never narrate which playbook files you opened.
- **Words to use:** "how we'll know it works" (not "Done-when"), "fine / needs fixing / couldn't check" (not PASS / FAIL / UNKNOWN), "plan" (not "spec gate"), "how strict the checks are" (not "level"). Never mention flags, the profile's internals or routing in chat; and never end a sentence with a bare level ("release-ready at L2"): say "ready for a free beta".
- **When you stop or ask**, give the reason in one sentence. Not "Stopping at G3", but "Before I write code, please approve this short plan. The change affects how your data is stored, so I want us to agree first."
- **When you ask a question**, say why the answer matters: "How strict should the checks be? A free beta with real users needs basic security and backups; a public paid launch also needs legal pages and monitoring."
- **The level** is "how strict the checks are". Describe it as what it means ("a free beta with real users"), not as L1-L4. If you use the code at all, put it in brackets after the words: "a free beta (level L2)".
- **Findings:** the problem in plain words, where it is, and the fix. An item ID may follow in brackets for lookup: "Buttons are 41px tall, too small to tap reliably on a phone; make them at least 44px (index.html:22) (UX-04)."
- **First session in a project** (no `docs/agent-profile.md` yet; skip this when a profile exists): introduce how you will work, in three short lines: you will confirm what "done" looks like before changing code, you will ask before installing, deploying or anything irreversible, and you will show proof (test output, screenshots) for every claim.
- **Files are different:** the ledger, profile and specs keep the IDs, because they are records to look up. Pair every ID there with a plain description too.
