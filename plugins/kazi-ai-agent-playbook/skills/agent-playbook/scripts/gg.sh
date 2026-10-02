#!/usr/bin/env bash
# Search helper for playbook Checks. Works with or without git.
# - Converts markdown-escaped "\|" back to "|" (Checks are copied from markdown tables).
# - In a git repo: git grep over tracked files (fast, honours .gitignore).
# - Not a git repo: grep -r, skipping dependency, build and cache folders; '*.ext' args become --include filters.
# Usage: gg [grep flags] 'pattern' [paths or '*.ext' globs...]
o=(); while [[ $1 == -* ]]; do o+=("$1"); shift; done
p="${1//\\|/|}"; shift
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exec git grep -nIE "${o[@]}" "$p" -- "${@:-.}"
fi
inc=(); paths=()
for a in "$@"; do
  if [[ $a == *'*'* && $a != */* ]]; then inc+=(--include="$a"); else paths+=("$a"); fi
done
[ ${#paths[@]} -eq 0 ] && paths=(.)
exec grep -rnIE --exclude-dir={node_modules,.git,dist,build,.next,out,generated,vendor,.venv,coverage,.cache,.turbo,.claude,.playwright-mcp} "${inc[@]}" "${o[@]}" -- "$p" "${paths[@]}"
