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

# 4e. a missing habits scenario fails
fresh
rm "$tmp/repo/evals/scenarios/mentor-plan/habits.md"
out="$(run)" && fail "a missing habits scenario should fail"
grep -q "no habits scenario" <<<"$out" || fail "the failure should name the scenario: $out"

# 4e2. a missing journal scenario fails, for the hint and the review skill
for k in hint review; do
  fresh
  rm "$tmp/repo/evals/scenarios/mentor-$k/journal.md"
  out="$(run)" && fail "a missing mentor-$k journal scenario should fail"
  grep -q "mentor-$k has no journal scenario" <<<"$out" || fail "the failure should name the scenario: $out"
done

# 4e3. a missing teach-back scenario fails
fresh
rm "$tmp/repo/evals/scenarios/mentor-review/teach-back.md"
out="$(run)" && fail "a missing teach-back scenario should fail"
grep -q "no teach-back scenario" <<<"$out" || fail "the failure should name the scenario: $out"

# 4e4. a missing handoff scenario fails
fresh
rm "$tmp/repo/evals/scenarios/mentor-hint/handoff.md"
out="$(run)" && fail "a missing handoff scenario should fail"
grep -q "no handoff scenario" <<<"$out" || fail "the failure should name the scenario: $out"

# 4f. a skill missing a required section, a skill at 100 lines and a description without Use when each fail the anatomy check
fresh
sed -i.bak '/^## Risks$/d' "$tmp/repo/skills/mentor-review/SKILL.md"
out="$(run)" && fail "a skill with no Risks section should fail"
grep -q "anatomy: mentor-review has no 'Risks' section" <<<"$out" || fail "the failure should name the section: $out"
fresh
while [ "$(wc -l < "$tmp/repo/skills/mentor-diagnose/SKILL.md")" -lt 100 ]; do echo "filler" >> "$tmp/repo/skills/mentor-diagnose/SKILL.md"; done
out="$(run)" && fail "a 100-line skill should fail"
grep -q "anatomy: mentor-diagnose SKILL.md is 100 lines or more" <<<"$out" || fail "the failure should name the length: $out"
fresh
sed -i.bak 's/Use when/Reach for it when/' "$tmp/repo/skills/mentor-plan/SKILL.md"
out="$(run)" && fail "a description without Use when should fail"
grep -q "anatomy: mentor-plan description has no 'Use when' clause" <<<"$out" || fail "the failure should name the description: $out"

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
