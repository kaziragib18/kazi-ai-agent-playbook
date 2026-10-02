#!/usr/bin/env bash
# One-shot project recon (~30 lines). Run once per session instead of exploring. Read-only, best effort: output is hints, confirm flags with the dev.
cd "${1:-.}" || exit 1
# Works with or without git: tracked files in a repo, otherwise find/grep skipping dependency, build and cache folders.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then GIT=1; else GIT=0; fi
EXD='node_modules|\.git|dist|build|\.next|out|generated|vendor|\.venv|coverage|\.cache|\.turbo|\.claude|\.playwright-mcp'
lsf() { if [ $GIT = 1 ]; then git ls-files -co --exclude-standard; else find . -type f 2>/dev/null | sed 's#^\./##' | grep -vE "(^|/)($EXD)/"; fi; }
M="package.json requirements.txt pyproject.toml go.mod Gemfile composer.json Cargo.toml pom.xml"
# dependency-name match only (avoids hits in scripts/descriptions)
dep() { grep -qiE -- "[\"' ]($1)[\"']?[[:space:]]*[:=<>~^ ]" $M 2>/dev/null || grep -qiE -- "^($1)([=<>~ ]|$)" requirements.txt 2>/dev/null; }
code() { local p="$1"; shift
  if [ $GIT = 1 ]; then local fl=(); while IFS= read -r -d '' f; do [ -f "$f" ] && fl+=("$f"); done < <(git ls-files -z -co --exclude-standard -- "$@" 2>/dev/null); [ ${#fl[@]} -gt 0 ] && grep -qIiE -- "$p" "${fl[@]}" 2>/dev/null; return; fi
  local inc=(); for g in "$@"; do inc+=(--include="$g"); done
  grep -rqIiE --exclude-dir={node_modules,.git,dist,build,.next,out,generated,vendor,.venv,coverage,.cache,.turbo,.claude,.playwright-mcp} "${inc[@]}" -- "$p" . 2>/dev/null; }
files() { lsf | grep -ciE -- "$1"; }
echo "## stack"; ls $M 2>/dev/null | tr '\n' ' '; for p in pnpm-lock.yaml yarn.lock package-lock.json bun.lockb uv.lock poetry.lock; do [ -f $p ] && printf 'pm:%s ' $p; done; echo
echo -n "framework: "; for f in next nuxt @remix-run/react astro @sveltejs/kit svelte vue react express fastify hono @nestjs/core django flask fastapi rails laravel/framework gin-gonic/gin; do dep "$f" && printf '%s ' "$f"; done; echo
R=$(lsf | grep -E '(^|/)(route\.(ts|js)|views\.py|urls\.py)$|(^|/)pages/api/|controllers?/' | head -40)
echo -n "flags: "
dep 'supabase|@supabase/[a-z-]+|next-auth|@auth/[a-z-]+|auth0|@clerk/[a-z-]+|firebase|passport|lucia|better-auth|devise|django-allauth' && printf 'auth '
dep 'prisma|@prisma/client|drizzle-orm|typeorm|sequelize|mongoose|knex|pg|postgres|mysql2|sqlalchemy|psycopg2?|gorm|activerecord' && printf 'db '
[ -n "$R" ] && printf 'api '
{ dep '@anthropic-ai/sdk|anthropic|openai|@google/genai|google-generativeai|langchain|ai'; } || code 'api\.anthropic\.com|api\.openai\.com|generativelanguage\.googleapis' && printf 'ai '
dep 'stripe|@paddle/[a-z-]+|@polar-sh/[a-z-]+|dodopayments|@lemonsqueezy/[a-z-]+|paypal' && printf 'pay '
dep 'resend|nodemailer|@sendgrid/mail|postmark|mailgun.js|@aws-sdk/client-sesv?2?' && printf 'email '
dep 'puppeteer|puppeteer-core|@sparticuz/chromium(-min)?' && printf 'render '
{ dep 'multer|formidable|busboy|pdf-parse|mammoth|unpdf'; } || code 'formData\(\)|multipart/form-data' && printf 'upload '
{ dep 'react|vue|svelte|solid-js|astro|tailwindcss' || [ "$(files '\.(html|tsx|jsx|vue|svelte|astro)$')" -gt 0 ]; } && printf 'ui '
[ "$(files '(^|/)(robots|sitemap)\.(ts|js|txt|xml)$')" -gt 0 ] && printf 'public '
[ "$(files '(^|/)admin(/|$)')" -gt 0 ] && printf 'admin? '
echo; echo "(not detectable: minors, lib -> ask dev)"
echo "## source dirs"; d=$(ls -d app src lib pages components server api prisma supabase migrations scripts styles public 2>/dev/null | tr '\n' ' '); echo "${d:-. (source files at the root)}"
echo "## routes/handlers"; echo "${R:-none}"
echo "## pages"; files '(^|/)page\.(tsx|jsx|js)$|(^|/)pages/[^_].*\.(tsx|jsx|vue|astro)$|index\.astro$' | xargs echo count:
echo "## ops/ci"; ls .github/workflows .github/dependabot.yml renovate.json vercel.json netlify.toml Dockerfile fly.toml .env.example 2>/dev/null | tr '\n' ' '; echo
echo "## presence (1=found)"
S='*.ts *.tsx *.js *.jsx *.mjs *.py *.go *.rb *.php *.vue *.svelte *.astro *.json'
p() { code "$2" $S && printf '%s=1 ' "$1" || printf '%s=0 ' "$1"; }
dep '@sentry/[a-z-]+|sentry-sdk|@bugsnag/[a-z-]+|rollbar' && printf 'error_tracking=1 ' || printf 'error_tracking=0 '; p csp 'Content-Security-Policy'; p ratelimit 'rate.?limit'; p ld_json 'ld\+json'; p captcha 'turnstile|recaptcha|hcaptcha'; p max_tokens 'max_tokens|maxTokens|max_output_tokens'; p html_sink 'dangerouslySetInnerHTML|v-html|innerHTML'
echo
for f in privacy terms not-found global-error loading robots sitemap; do printf '%s=%s ' $f "$(files "(^|/)$f(/|\.[a-z]+$)")"; done
printf 'health_route=%s manifest=%s\n' "$(files '(^|/)api/health(z|check)?(/|\.[a-z]+$)|(^|/)health(z)?/route\.[a-z]+$')" "$(files '(^|/)(manifest\.(json|webmanifest)|site\.webmanifest|app/manifest\.(ts|js))$')"
echo "## tests"; printf 'test files: %s  api route tests: %s\n' "$(files '\.(test|spec)\.|(^|/)test_[^/]*\.py$|(^|/)tests?\.(js|mjs|ts)$|(^|/)(tests?|__tests__)/')" "$(lsf | grep -E '(^|/)api/' | grep -cE '\.(test|spec)\.')"
echo "## scripts"; grep -A30 '"scripts"' package.json 2>/dev/null | grep -E '"(dev|build|start|test|lint|typecheck|e2e|audit)[^"]*"' | sed 's/^ *//' | head -10
echo "## git"; if [ $GIT = 1 ]; then git symbolic-ref --short HEAD 2>/dev/null; git rev-parse --short HEAD 2>/dev/null || echo "(no commits yet: profile commit stays none until the first commit)"; git status --short | wc -l | xargs echo dirty:; else echo "not a git repo (fine): checks use plain grep; freshness uses file dates"; fi
