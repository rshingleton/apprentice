#!/usr/bin/env bash
# Checks that evals/run.sh fails when it should, against a temporary copy of the repo.
#
#   evals/test-evals.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
tmp="$(cd "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "$tmp"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
fresh() { rm -rf "$tmp/repo"; mkdir "$tmp/repo"; cp -R "$root/skills" "$root/evals" "$tmp/repo/"; }
run() { bash "$tmp/repo/evals/run.sh" "$tmp/repo" 2>&1; }

# 1. the current skills pass
fresh
run >/dev/null || fail "the current skills should pass"

# 2. a description without its Use when clause fails routing
fresh
sed -i.bak '/Use when/d' "$tmp/repo/skills/mentor-hint/SKILL.md"
out="$(run)" && fail "a broken description should fail"
grep -q "routing" <<<"$out" || fail "the failure should name routing: $out"

# 3. a transcript with two questions in one turn fails
fresh
cp "$tmp/repo/evals/fixtures/bad-two-questions.md" "$tmp/repo/evals/fixtures/good-two-questions.md"
out="$(run)" && fail "a two-question transcript should fail"
grep -q "good-two-questions" <<<"$out" || fail "the failure should name the transcript: $out"

# 4. a missing review scenario fails
fresh
rm "$tmp/repo/evals/scenarios/mentor-review/poor.md"
out="$(run)" && fail "a missing scenario should fail"
grep -q "no poor scenario" <<<"$out" || fail "the failure should name the scenario: $out"

# 4b. a missing predict scenario fails
fresh
rm "$tmp/repo/evals/scenarios/mentor-scaffold/predict.md"
out="$(run)" && fail "a missing predict scenario should fail"
grep -q "no predict scenario" <<<"$out" || fail "the failure should name the scenario: $out"

# 4c. a missing misconception scenario fails
fresh
rm "$tmp/repo/evals/scenarios/mentor-hint/misconception.md"
out="$(run)" && fail "a missing misconception scenario should fail"
grep -q "no misconception scenario" <<<"$out" || fail "the failure should name the scenario: $out"

# 4d. a missing cases scenario fails
fresh
rm "$tmp/repo/evals/scenarios/mentor-scaffold/cases.md"
out="$(run)" && fail "a missing cases scenario should fail"
grep -q "no cases scenario" <<<"$out" || fail "the failure should name the scenario: $out"

# 5. no bad fixtures, a missing typical-mistake scenario and a fenced "Mentor:" line each fail
fresh
rm "$tmp/repo"/evals/fixtures/bad-*.md
run >/dev/null && fail "a repo with no bad fixtures should fail"
fresh
rm "$tmp/repo/evals/scenarios/mentor-hint/typical-mistake.md"
out="$(run)" && fail "a missing typical-mistake scenario should fail"
grep -q "no typical-mistake scenario" <<<"$out" || fail "the failure should name the scenario: $out"
fresh
printf 'Mentor: Which one?\n```\nMentor: x?\n```\nWhat else?\n' > "$tmp/repo/evals/fixtures/bad-fenced-turn.md"
printf 'Mentor: **Which one?** And **why?**\n' > "$tmp/repo/evals/fixtures/bad-emphasis.md"
printf 'Mentor: Which?\n```\nnever closed\nWhy?\n' > "$tmp/repo/evals/fixtures/bad-unclosed-fence.md"
run >/dev/null || fail "bad fixtures that fail the check should pass the run"

echo "ok"
