# B7. Session hygiene and task flow


Every message resends the whole conversation, so long sessions cost more per turn and drift. Work in small, independent units.

**Start a fresh session / subagent when:** the task changes · a phase or plan item is done · context is about half full (check the tool's context/usage view) · the agent repeats itself or re-asks settled things · a fix or review is needed after a long session. **Keep going when:** steps depend on what was just learned (one bug, one refactor across the same files) or it is a short follow-up.

**One task = one unit:**
```
Task:        <one sentence outcome>
Done when:   <command or observable check, e.g. "<test cmd> passes and screenshot at 390px shows Y">
Files:       <paths in scope; anything else is out of scope>
Load:        SKILL.md + playbook <§B…> + modules <ids> (+ skills by name)
Constraints: <must not break / must reuse>
Handoff:     <where the result is written>
```
Plans live in a file (e.g. `docs/plans/<phase>.md`), not in chat; each task is one vertical slice from §B10 step 4. A fresh agent starts from: the task block + SKILL.md (~1.5k tokens) + one playbook section (~1k) + one module (~1k) + the project profile (`docs/agent-profile.md`) (~0.5k), about 4k tokens in total.

**Handoff note (written before ending a session, 10 lines max):** what changed (files) · checks run with result · what is left · open decisions for the dev · gotchas discovered. Put it in the plan file or ledger, never only in chat.

**Fixes and reviews go to a fresh agent** given the failing output and the diff, not back into the long session. A reviewer must not see the author's reasoning.

**Task sizing:** if "Done when" cannot be checked in one run, or the task touches more than ~5 files across more than one module, split it. If you cannot write the handoff in 10 lines, the task is too big or too coupled.
