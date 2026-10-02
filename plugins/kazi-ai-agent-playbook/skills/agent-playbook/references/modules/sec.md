# MODULE sec — SEC security

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


Checks use `git grep` (tracked files only, fast). `gg` = `git grep -nE`. Replace `SRC` with source dirs from recon. Lvl = minimum level at which required.

## Secrets and config
| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| SEC-01 | L1 | all | No secrets or `.env` in git | git: `git ls-files '.env*' '*/.env*'` → only `.env.example`; no git yet: `find . -name '.env*' -not -path '*/node_modules/*'` and confirm `.gitignore` lists `.env` before the first commit; `gg 'AKIA[0-9A-Z]{16}\|sk_live_\|-----BEGIN [A-Z ]*PRIVATE\|eyJ[A-Za-z0-9_-]{30,}\.'` → none |
| SEC-02 | L1 | all | Server secrets never reach client bundle (only public-prefixed vars `NEXT_PUBLIC_`/`VITE_`/`PUBLIC_` in client code) | [js] `gg 'process\.env\.[A-Z_]+' $(git grep -l 'use client' -- $SRC)` → public-prefixed only; `gg 'SERVICE_ROLE\|SECRET' $SRC` outside server files → none |
| SEC-03 | L2 | all | `.env.example` lists every variable; env validated at boot (schema) so missing config fails fast | `gg -l 'createEnv\|envsafe\|z\.object\(.*process\.env\|parse\(process\.env' $SRC` → ≥ 1; compare `.env.example` keys to `gg -o 'process\.env\.[A-Z_]+' $SRC` |
| SEC-04 | L3 | all | Secret scanning on (push protection / gitleaks in CI) and rotation steps documented | ls `.github`; ops doc |

## Authentication and authorization
| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| SEC-10 | L2 | auth | Server verifies identity with the auth server/JWT signature, not an unverified client claim (e.g. Supabase `getUser()` not `getSession()`; never trust decoded-but-unverified JWT) | `gg 'getSession\(\|jwt\.decode\|jwtDecode' $SRC` → none on server paths |
| SEC-11 | L2 | auth api | Every non-public handler authenticates first and returns 401 | list handlers (recon) minus public/cron/webhook; `gg -L 'getUser\|requireUser\|auth\(' <handler files>` → only intentional |
| SEC-12 | L2 | auth db | Object-level authorization: every query by id also filters by owner/tenant (IDOR/BOLA). ORMs on a privileged DB role bypass RLS, so app code must filter | [js/ORM] `gg '(findUnique\|findFirst\|findMany\|update\|delete)\(' $SRC` → each `where` has owner/tenant |
| SEC-13 | L2 | db | Row-level security (or equivalent) enabled on every user-data table; policies re-applied after migrations | count `enable row level security` vs table/model count |
| SEC-14 | L2 | auth | Redirect/`next` params validated as same-origin relative paths | `gg 'searchParams.get\(.(next\|redirect\|returnTo)' $SRC` → validated |
| SEC-15 | L2 | auth | Session in HttpOnly+Secure+SameSite cookies; no tokens in localStorage | `gg '(localStorage\|sessionStorage).*(token\|auth\|session)' $SRC` → none |
| SEC-16 | L2 | auth api | State change only via POST/PUT/PATCH/DELETE; GET is safe; CSRF covered by SameSite or tokens | list GET handlers; none mutate |
| SEC-17 | L2 | auth | Cron/webhook/internal endpoints require a shared secret or signature | `gg 'CRON_SECRET\|x-.*-signature\|authorization' $SRC` per handler |
| SEC-18 | L3 | auth | Logout revokes; session expiry handled gracefully in UI | manual / E2E |
| SEC-19 | L3 | auth | If passwords exist: Argon2id or bcrypt cost >= 12, breach/length policy, reset flow rate-limited. Passwordless/OAuth: N/A | `gg 'bcrypt\|argon2\|password' $SRC` |
| SEC-20 | L3 | admin | Admin routes: server-side role check + MFA + audit log | `find`/recon for `admin` |
| SEC-21 | L4 | auth | MFA offered to all; SSO for enterprise | product |

## Input, output, abuse
| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| SEC-30 | L1 | all | All external input (body, query, headers, files, webhooks) validated by a schema at the boundary with size caps | `gg -L 'safeParse\|\.parse\(\|validate' <handler files>` → only bodyless |
| SEC-31 | L1 | db | Parameterized queries only; no string-built SQL | `gg '(query\|execute\|\$queryRaw\|raw)\(.*(\$\{\|\+ ?[a-z])' $SRC` → none |
| SEC-32 | L2 | ui | No user-controlled HTML sink: `dangerouslySetInnerHTML`, `innerHTML`, `v-html`, `eval`. JSON-LD with dynamic data must escape `<` as the six characters `\u003c` | `gg 'dangerouslySetInnerHTML\|innerHTML\|v-html\|eval\(' $SRC` → each hit is static or sanitized |
| SEC-33 | L2 | public api | Rate limits on login, signup, reset, AI, search, export, upload; limiter works across instances (DB/Redis, not in-memory) | `gg 'rate.?limit' $SRC`; read limiter once |
| SEC-34 | L2 | public | Bot protection (Turnstile/hCaptcha/reCAPTCHA) on unauthenticated costly endpoints | `gg 'turnstile\|recaptcha\|hcaptcha' $SRC` |
| SEC-35 | L2 | upload | Server-side file checks: magic-byte type, extension allowlist, byte cap, per-user path, `nosniff`; parsers bounded (pages/time/memory) | read upload handlers once |
| SEC-36 | L2 | render api | SSRF: server never fetches or navigates a user-supplied URL; headless browsers go only to own origin (request interception) | `gg 'fetch\(\|goto\(\|axios' $SRC` → URL origin fixed |
| SEC-37 | L2 | all | CORS: no `*` with credentials; explicit origins | `gg 'Access-Control' $SRC next.config.* vercel.json` |
| SEC-38 | L2 | all | Errors: generic message to client, detail to logs; no stack in responses | `gg 'err(or)?\.stack' $SRC` |
| SEC-39 | L2 | all | Logs exclude PII, tokens, prompts, document bodies | `gg 'console\.(log\|error\|warn)\(.*(token\|email\|password\|prompt\|body)' $SRC` |
| SEC-40 | L3 | pay | Webhook: verify signature on raw body, idempotent by event id | see `references/modules/pay.md` |

## Hardening and supply chain
| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| SEC-50 | L3 | public | Security headers: CSP, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, `Permissions-Policy`, `frame-ancestors`/`X-Frame-Options`, HSTS | `gg 'Content-Security-Policy\|frame-ancestors\|Strict-Transport' $SRC next.config.* vercel.json netlify.toml` |
| SEC-51 | L3 | all | Dependency audit clean of high/critical in CI; Dependabot/Renovate on | `ls .github/dependabot.yml renovate.json`; `pnpm audit --prod --audit-level=high` |
| SEC-52 | L3 | all | Lockfile committed; CI uses frozen install | `ls *lock*`; CI file |
| SEC-53 | L3 | all | Debug/dev flags off in production; no source-map or stack disclosure | `gg 'NODE_ENV\|DEBUG' $SRC`; build config |
| SEC-54 | L3 | api | Request body size limits at proxy and route | framework config |
| SEC-55 | L4 | all | SAST (CodeQL/Semgrep) + DAST in CI; periodic pentest | workflows |
| SEC-56 | L4 | all | Key rotation, `security.txt`, audit logging for sensitive actions | docs |
