#!/usr/bin/env bash
# Search helper for playbook Checks. Works with or without git, before or after the first commit.
# - Converts markdown-escaped "\|" back to "|" (Checks are copied from markdown tables).
# - Git repo: git lists the files (tracked + untracked, .gitignore respected); grep searches them.
#   (git grep alone misses uncommitted files and does not support \b on macOS.)
# - No git: grep -r, skipping dependency, build and cache folders; '*.ext' args become --include filters.
# Exit status follows grep: 0 = match, 1 = no match. Usage: gg [grep flags] 'pattern' [paths or '*.ext' globs...]
o=(); while [[ $1 == -* ]]; do o+=("$1"); shift; done
p="${1//\\|/|}"; shift
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  files=()
  while IFS= read -r -d '' f; do [ -f "$f" ] && files+=("$f"); done < <(git ls-files -z -co --exclude-standard -- "${@:-.}" 2>/dev/null)
  [ ${#files[@]} -eq 0 ] && exit 1
  exec grep -HnIE "${o[@]}" -- "$p" "${files[@]}"   # ponytail: one grep call; very large repos could hit ARG_MAX, switch to xargs then
fi
inc=(); paths=()
for a in "$@"; do
  if [[ $a == *'*'* && $a != */* ]]; then inc+=(--include="$a"); elif [ -e "$a" ]; then paths+=("$a"); else missing=1; fi
done
# Missing paths (e.g. no package.json) are skipped like git does; if every named path is missing, report "no match".
if [ ${#paths[@]} -eq 0 ]; then [ -n "$missing" ] && exit 1; paths=(.); fi
exec grep -rnIE --exclude-dir={node_modules,.git,dist,build,.next,out,generated,vendor,.venv,coverage,.cache,.turbo,.claude,.playwright-mcp} "${inc[@]}" "${o[@]}" -- "$p" "${paths[@]}"
