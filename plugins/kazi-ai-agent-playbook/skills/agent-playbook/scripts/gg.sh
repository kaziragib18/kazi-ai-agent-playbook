#!/usr/bin/env bash
# git grep wrapper for playbook Checks: converts markdown-escaped "\|" back to "|", searches tracked files only.
# Usage: gg [git-grep flags] 'pattern' [paths...]
o=(); while [[ $1 == -* ]]; do o+=("$1"); shift; done
p="${1//\\|/|}"; shift
exec git grep -nIE "${o[@]}" "$p" -- "${@:-.}"
