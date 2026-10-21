#!/usr/bin/env bash
# Offline checks for the mentor skills. Prints each failure and exits non-zero if there was one.
#
#   evals/run.sh [repo-root]
set -uo pipefail

root="$(cd "${1:-$(dirname "${BASH_SOURCE[0]}")/..}" && pwd -P)"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
evals="$root/evals"
status=0

fail() { echo "FAIL: $*" >&2; status=1; }

# Frontmatter value of $2 in file $1; a folded ">" block is joined into one line.
field() {
  awk -v key="$2" '
    NR == 1 { next }
    /^---$/ { exit }
    $0 ~ "^" key ":" { sub("^" key ":[ \t]*", ""); out = $0; grab = 1; next }
    grab && /^[ \t]/ { out = out " " $0; next }
    { grab = 0 }
    END { gsub(/^[ \t>]+|[ \t]+$/, "", out); gsub(/[ \t]+/, " ", out); print out }
  ' "$1"
}

skills=()
for d in "$root"/skills/*/; do skills+=("$(basename "$d")"); done
[ "${#skills[@]}" -gt 0 ] || fail "no skills under $root/skills"

# 1. each skill has a name matching its directory and a description
for s in "${skills[@]}"; do
  f="$root/skills/$s/SKILL.md"
  [ -f "$f" ] || { fail "$s: no SKILL.md"; continue; }
  [ "$(field "$f" name)" = "$s" ] || fail "$s: frontmatter name does not match the directory"
  [ -n "$(field "$f" description)" ] || fail "$s: description is empty"
done

# 2. routing: every skill has cases; each trigger is in its description and in no other
while IFS=$'\t' read -r skill prompt trigger; do
  [ -n "$skill" ] || continue
  [ -f "$root/skills/$skill/SKILL.md" ] || { fail "routing: unknown skill $skill"; continue; }
  for s in "${skills[@]}"; do
    desc="$(field "$root/skills/$s/SKILL.md" description | tr '[:upper:]' '[:lower:]')"
    case "$desc" in
      *"$(printf %s "$trigger" | tr '[:upper:]' '[:lower:]')"*) hit=1 ;;
      *) hit=0 ;;
    esac
    if [ "$s" = "$skill" ] && [ "$hit" = 0 ]; then fail "routing: '$trigger' is missing from the $s description"; fi
    if [ "$s" != "$skill" ] && [ "$hit" = 1 ]; then fail "routing: '$trigger' also appears in the $s description"; fi
  done
done < "$evals/routing.tsv"
for s in "${skills[@]}"; do
  [ "$(grep -c "^$s	" "$evals/routing.tsv")" -ge 2 ] || fail "routing: $s needs at least two cases"
done

# 3. scenarios: structure, and the kinds each skill must have
for s in "${skills[@]}"; do
  dir="$evals/scenarios/$s"
  [ -f "$dir/ask-for-answer.md" ] || fail "scenarios: $s has no ask-for-answer scenario"
  case "$s" in mentor-hint|mentor-scaffold|mentor-diagnose)
    [ -f "$dir/typical-mistake.md" ] || fail "scenarios: $s has no typical-mistake scenario" ;;
  esac
  [ "$s" != mentor-hint ] || [ -f "$dir/misconception.md" ] || fail "scenarios: $s has no misconception scenario"
  [ "$s" != mentor-scaffold ] || [ -f "$dir/cases.md" ] || fail "scenarios: $s has no cases scenario"
  case "$s" in mentor-scaffold|mentor-diagnose)
    [ -f "$dir/predict.md" ] || fail "scenarios: $s has no predict scenario" ;;
  esac
  if [ "$s" = mentor-review ]; then
    for k in great middling poor; do [ -f "$dir/$k.md" ] || fail "scenarios: $s has no $k scenario"; done
  fi
done
for f in "$evals"/scenarios/*/*.md; do
  [ -f "$f" ] || continue
  kind="$(basename "$f" .md)"; skill="$(basename "$(dirname "$f")")"
  [ "$(field "$f" skill)" = "$skill" ] || fail "scenarios: $f skill does not match its directory"
  case "$kind" in ask-for-answer|typical-mistake|predict|misconception|cases|great|middling|poor) ;; *) fail "scenarios: $f has an unknown kind" ;; esac
  [ "$(field "$f" kind)" = "$kind" ] || fail "scenarios: $f kind does not match its filename"
  for sec in Script Expect; do
    awk -v sec="## $sec" '$0 == sec { on = 1; next } /^## / { on = 0 } on && NF { n++ } END { exit n == 0 }' "$f" \
      || fail "scenarios: $f has an empty or missing $sec section"
  done
done

# 4. transcript fixtures: good ones pass the one-question check, bad ones fail it
good=0; bad=0
for f in "$evals"/fixtures/good-*.md; do
  [ -f "$f" ] || continue
  good=$((good + 1))
  "$here/check-transcript.sh" "$f" >/dev/null || fail "fixture $f should pass the question check"
done
for f in "$evals"/fixtures/bad-*.md; do
  [ -f "$f" ] || continue
  bad=$((bad + 1))
  "$here/check-transcript.sh" "$f" >/dev/null 2>&1; rc=$?
  [ "$rc" = 1 ] || fail "fixture $f should fail the question check with status 1, got $rc"
done
[ "$good" -ge 1 ] && [ "$bad" -ge 1 ] || fail "fixtures: need at least one good and one bad transcript"

[ "$status" = 0 ] && echo "ok: ${#skills[@]} skills"
exit "$status"
