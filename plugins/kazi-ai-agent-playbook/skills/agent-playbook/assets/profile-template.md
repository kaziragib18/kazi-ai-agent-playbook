# Project profile template

Copy this file to `docs/agent-profile.md` in the project and fill it in. Never reuse another project's profile.

```
commit:    <git rev-parse --short HEAD>      verified: <YYYY-MM-DD>      method: <grep scan | + tests run | + browser>
level:     L1 | L2 | L3 | L4                 (ask the dev if unknown, §B5)
type:      <saas | mvp | frontend | api | internal | ai app | library>
flags:     <auth db api ai pay upload render public ui email minors admin lib>   (recon output + dev corrections)
stack:     <framework, ORM, auth, host, DB tier>        (from recon; note platform limits such as function timeout, DB size, idle pause, commercial-use terms)
src dirs:  <from recon; never assume names like components/ or src/>
project rules that override level: <non-negotiable invariants from the repo's own docs, e.g. "run X regression after Y">
```

## Routing: changed path → modules (fill from recon routes and dirs)
| Path glob | Modules (and item ranges) |
|---|---|
| <auth/session/middleware files> | sec(10-19) qa(09) |
| <api/route handlers> | sec qa(04) ops(05) |
| <db schema/migrations/repositories> | sec(12,13) perf(02-05) ops(03,11) |
| <AI/LLM code> | ai sec(30,32) |
| <billing/checkout/webhooks> | pay legal(10) |
| <marketing/public pages, sitemap, robots, metadata> | seo ux legal |
| <app UI components, styles/tokens> | ux perf(07,08) qa(10) |
| <package manifest, lockfile, framework/host config, CI> | sec(50-54) ops qa(07) |
| release candidate | all items with Lvl ≤ level |

## Check translations (non-JS stacks)
`<ID>: <this stack's equivalent command>`; one line each, written the first time a `[js]`/`[next]` Check is translated.

## Accepted exceptions (subtract before reporting; re-check only if the file changed)
`<ID> | <file:line> | <why it is intentional> | <date> | approved by <dev>`; e.g. static JSON-LD for SEC-32, raw colors in an OG-image renderer for UX-01.

Statuses are not kept here: the ledger (§B6) is the only status store.

## Decisions (do not re-ask)
Dated answers from the dev: confirmed level, skills approved or declined (`references/skill-registry.md` §Missing), business facts (entity, regions, minors, refund terms), accepted risks.
