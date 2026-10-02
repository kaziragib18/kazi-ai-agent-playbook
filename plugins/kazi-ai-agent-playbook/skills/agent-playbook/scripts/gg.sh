#!/usr/bin/env bash
# Search helper for playbook Checks. Works with or without git, before or after the first commit.
# - Converts markdown-escaped "\|" back to "|" (Checks are copied from markdown tables).
# - Git repo: git lists the files (tracked + untracked, .gitignore respected); grep searches them.
#   (git grep alone misses uncommitted files and does not support \b on macOS.)
# - No git: grep -r, skipping dependency, build and cache folders; '*.ext' args become --include filters.
# Exit status: 0 = match, 1 = no match, 2 = bad pattern or path (an error, NEVER "no hits"). Usage: gg [grep flags] 'pattern' [paths or '*.ext' globs...]
err() { echo "gg: bad pattern or path (exit 2): this is an ERROR, not 'no hits'. Escape literal ( ) [ ] { } . + ? as \\( \\) etc. Pattern: $p" >&2; exit 2; }
o=(); while [[ $1 == -* ]]; do o+=("$1"); shift; done
p="${1//\\|/|}"; shift
# zsh (macOS default) does not word-split $SRC, so "a.js b.js" arrives as ONE argument. Split such
# arguments when they are not a real path, so Checks behave the same in bash and zsh.
args=(); for a in "$@"; do
  if [[ $a == *' '* && ! -e $a ]]; then read -r -a parts <<< "$a"; args+=("${parts[@]}"); else args+=("$a"); fi
done
set -- "${args[@]}"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  files=()
  while IFS= read -r -d '' f; do [ -f "$f" ] && files+=("$f"); done < <(git ls-files -z -co --exclude-standard -- "${@:-.}" 2>/dev/null)
  [ ${#files[@]} -eq 0 ] && exit 1
  grep -HnIE "${o[@]}" -- "$p" "${files[@]}"   # ponytail: one grep call; very large repos could hit ARG_MAX, switch to xargs then
  rc=$?; [ $rc -ge 2 ] && err; exit $rc
fi
inc=(); paths=()
for a in "$@"; do
  if [[ $a == *'*'* && $a != */* ]]; then inc+=(--include="$a"); elif [ -e "$a" ]; then paths+=("$a"); else missing=1; fi
done
# Missing paths (e.g. no package.json) are skipped like git does; if every named path is missing, report "no match".
if [ ${#paths[@]} -eq 0 ]; then [ -n "$missing" ] && exit 1; paths=(.); fi
grep -rnIE --exclude-dir={node_modules,.git,dist,build,.next,out,generated,vendor,.venv,coverage,.cache,.turbo,.claude,.playwright-mcp} "${inc[@]}" "${o[@]}" -- "$p" "${paths[@]}"
rc=$?; [ $rc -ge 2 ] && err; exit $rc
