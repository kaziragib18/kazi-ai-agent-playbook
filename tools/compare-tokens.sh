#!/usr/bin/env bash
# Maintainer tool (not part of the installed plugin). Measure the playbook's token impact on YOUR project: run the same task with and without the plugin
# in throwaway copies, then print tokens, cost, time and files changed side by side.
#
# Usage:  bash compare-tokens.sh "<task prompt>" [project-dir] [runs]
#   e.g.  bash compare-tokens.sh "Add a dark mode toggle" . 3
# Env:    PERMISSION_MODE (default: auto) · FROM=HEAD compares on the last commit instead of your working folder.
#         Copies are kept for inspection.
#
# Costs real money: it runs 2 x runs Claude Code sessions (4 x if a side stops to ask for approval, see below).
# Your project itself is never modified; the copies have their git remotes removed so they cannot push.
# One run per side is noisy; use 3 or more runs before drawing conclusions.
#
# A run that stops with no file changes (the playbook asks for a plan first) is resumed once with "approved,
# go ahead" and both parts are added up, on either side, so both sides are measured finishing the job.
set -u
TASK=${1:?usage: compare-tokens.sh "<task prompt>" [project-dir] [runs]}
PROJ=$(cd "${2:-.}" && pwd) || exit 1
RUNS=${3:-1}
MODE=${PERMISSION_MODE:-auto}
PLUGIN_ROOT=$(cd "$(dirname "$0")/../plugins/kazi-ai-agent-playbook" && pwd)
PLUGIN_ID="kazi-ai-agent-playbook@kazi-playbook"
PLUGIN_VERSION=$(python3 -c "import json,sys;print(json.load(open(sys.argv[1]))['version'])" "$PLUGIN_ROOT/.claude-plugin/plugin.json" 2>/dev/null || echo unknown)
command -v claude >/dev/null || { echo "claude CLI not found" >&2; exit 1; }
command -v python3 >/dev/null || { echo "python3 not found" >&2; exit 1; }

WORK=$(mktemp -d "${TMPDIR%/}/playbook-compare.XXXXXX" 2>/dev/null || mktemp -d /tmp/playbook-compare.XXXXXX)
# Turn the installed plugin off for both runs (user and project scope), so "without" really is without;
# the "with" run loads this exact plugin version via --plugin-dir instead.
OFF="{\"enabledPlugins\":{\"$PLUGIN_ID\":false}}"

copy() { # copy project, skipping heavy/generated folders
  if [ "${FROM:-}" = HEAD ]; then (cd "$PROJ" && git archive HEAD) | tar -x -C "$1" && cp -R "$PROJ/.git" "$1/.git" && return
  fi
  if command -v rsync >/dev/null; then
    rsync -a --exclude node_modules --exclude .next --exclude dist --exclude build --exclude .venv --exclude coverage "$PROJ/" "$1/"
  else cp -R "$PROJ/." "$1/"; fi
}

run() { # $1=label $2=index
  local dir="$WORK/$1-$2"; mkdir -p "$dir"; copy "$dir"
  # Snapshot the starting state inside the copy, so "files changed" counts only what this run changed,
  # then drop every remote: a session in a copy must never be able to push anywhere.
  ( cd "$dir" && { git rev-parse --is-inside-work-tree >/dev/null 2>&1 || git init -q; } && git add -A && git -c user.name=compare -c user.email=compare@local commit -qm "compare: starting state" --no-verify --allow-empty
    for r in $(git remote); do git remote remove "$r"; done ) >/dev/null 2>&1
  local extra=(); [ "$1" = with ] && extra=(--plugin-dir "$PLUGIN_ROOT")
  local t0=$(date +%s)
  ( cd "$dir" && claude -p "$TASK" ${extra[@]+"${extra[@]}"} --settings "$OFF" --permission-mode "$MODE" --output-format json > "$WORK/$1-$2.json" 2> "$WORK/$1-$2.err" )
  local changed=$( cd "$dir" && git status --short --untracked-files=all | wc -l | tr -d ' ' )
  if [ "$changed" = 0 ]; then   # stopped to ask for approval: continue the same session once
    local sid=$(python3 -c "import json,sys;print(json.load(open(sys.argv[1])).get('session_id',''))" "$WORK/$1-$2.json" 2>/dev/null)
    if [ -n "$sid" ]; then
      ( cd "$dir" && claude -p "Yes, approved. Go ahead and finish it." --resume "$sid" ${extra[@]+"${extra[@]}"} --settings "$OFF" --permission-mode "$MODE" --output-format json > "$WORK/$1-$2.b.json" 2> "$WORK/$1-$2.b.err" )
      changed=$( cd "$dir" && git status --short --untracked-files=all | wc -l | tr -d ' ' )
    fi
  fi
  echo $(( $(date +%s) - t0 )) > "$WORK/$1-$2.secs"
  echo "$changed" > "$WORK/$1-$2.changed"
}

if [ "${FROM:-}" != HEAD ] && [ -n "$(cd "$PROJ" && git status --porcelain 2>/dev/null)" ]; then
  echo "Note: $PROJ has uncommitted changes; both runs start from that working state. Use FROM=HEAD to start from the last commit."
fi
echo "Task:    $TASK"
echo "Project: $PROJ  (copied; never modified; remotes removed in the copies)"
echo "Plugin:  $PLUGIN_ROOT  (version $PLUGIN_VERSION)"
echo "Runs:    $RUNS per side, at least $((RUNS*2)) sessions in total. Working in $WORK"
for i in $(seq 1 "$RUNS"); do
  echo "  run $i/$RUNS: with and without the playbook, in parallel..."
  run with "$i" & run without "$i" & wait
done

python3 - "$WORK" "$RUNS" "$PLUGIN_VERSION" <<'PY'
import json, sys, statistics as st, os
work, runs, version = sys.argv[1], int(sys.argv[2]), sys.argv[3]
def tokens(d):  # all models together (the cheap helper model is included), same basis as the cost figure
    t = {"new input": 0, "cache reads": 0, "output": 0}
    for m in (d.get("modelUsage") or {}).values():
        t["new input"] += m.get("inputTokens", 0) + m.get("cacheCreationInputTokens", 0)
        t["cache reads"] += m.get("cacheReadInputTokens", 0)
        t["output"] += m.get("outputTokens", 0)
    if not any(t.values()):
        u = d.get("usage", {})
        t = {"new input": u.get("input_tokens", 0) + u.get("cache_creation_input_tokens", 0),
             "cache reads": u.get("cache_read_input_tokens", 0), "output": u.get("output_tokens", 0)}
    return t
def load(side):
    rows = []
    for i in range(1, runs + 1):
        parts, ok = [], True
        for suffix in (".json", ".b.json"):
            p = f"{work}/{side}-{i}{suffix}"
            if not os.path.exists(p): continue
            try: parts.append(json.load(open(p)))
            except Exception: ok = False
        if not parts or not ok:
            print(f"  ! {side} run {i} produced no result (see {work}/{side}-{i}.err)"); continue
        row = {"new input": 0, "cache reads": 0, "output": 0, "cost $": 0.0, "turns": 0}
        for d in parts:
            for k, v in tokens(d).items(): row[k] += v
            row["cost $"] += d.get("total_cost_usd", 0.0)
            row["turns"] += d.get("num_turns", 0)
        row["seconds"] = int(open(f"{work}/{side}-{i}.secs").read() or 0)
        row["files changed"] = int(open(f"{work}/{side}-{i}.changed").read() or 0)
        row["asked first"] = 1 if len(parts) > 1 else 0
        row["total tokens"] = row["new input"] + row["cache reads"] + row["output"]
        rows.append(row)
    return rows
w, wo = load("with"), load("without")
if not w or not wo: sys.exit("Not enough results to compare.")
keys = ["total tokens", "new input", "cache reads", "output", "cost $", "seconds", "turns", "files changed"]
mean = lambda rows, k: st.mean(r[k] for r in rows)
fmt = lambda k, v: f"{v:,.2f}" if k == "cost $" else f"{v:,.0f}"
print(f"\n{'':16}{'with playbook':>16}{'without':>14}{'difference':>14}")
for k in keys:
    a, b = mean(w, k), mean(wo, k)
    diff = f"{(a - b) / b * 100:+.0f}%" if b else "-"
    print(f"{k:16}{fmt(k, a):>16}{fmt(k, b):>14}{diff:>14}")
print(f"\n(playbook version {version}; averages over {len(w)} / {len(wo)} runs; cache reads are billed at a fraction of new input)")
print(f"Runs that stopped for approval and were resumed: with {sum(r['asked first'] for r in w)}/{len(w)}, without {sum(r['asked first'] for r in wo)}/{len(wo)}.")
print("Read the result, not just the numbers: compare what each run actually did. A run that writes")
print("code before agreeing on a plan can look cheaper now and cost far more in rework later.")
print(f"Copies kept for inspection: {work}/with-* and {work}/without-*")
print(f"Final replies: {work}/with-1[.b].json and {work}/without-1[.b].json (field \"result\")")
PY
