#!/usr/bin/env bash
# Checks hooks/phase-guard.sh against a temporary project, never this repo.
#
#   scripts/test-phase-guard.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
guard="$root/hooks/phase-guard.sh"
tmp="$(cd "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "$tmp"' EXIT
proj="$tmp/proj"
mkdir -p "$proj/docs/planning/t1/phase-1" "$proj/docs/planning/t2/phase-1"
marker="$proj/docs/planning/t1/phase-1/ACTIVE"

fail() { echo "FAIL: $*" >&2; exit 1; }
# call <tool> <field> <path>: the hook's stdout for one tool call in the project
call() {
  printf '{"tool_name":"%s","cwd":"%s","tool_input":{"%s":"%s"}}' "$1" "$proj" "$2" "$3" | bash "$guard"
}
denied() { [[ "$(call "$@")" == *'"permissionDecision":"deny"'* ]]; }
allowed() { [ -z "$(call "$@")" ]; }

# 1. no marker: everything is allowed
allowed Edit file_path "$proj/src/a.js" || fail "no marker should allow"

# 2. a marker denies its listed paths and itself, and allows the rest
printf '%s\n' '# stub for phase 1' '' 'src/a.js' > "$marker"
denied Edit file_path "$proj/src/a.js" || fail "listed path should be denied"
denied Write file_path "$proj/src/a.js" || fail "Write on a listed path should be denied"
denied MultiEdit file_path "$proj/src/a.js" || fail "MultiEdit on a listed path should be denied"
denied NotebookEdit notebook_path "$proj/src/a.js" || fail "NotebookEdit on a listed path should be denied"
denied Edit file_path "$marker" || fail "the marker itself should be denied"
allowed Edit file_path "$proj/src/a.test.js" || fail "the test file should be allowed"
allowed Write file_path "$proj/exercises/e.js" || fail "exercises/ should be allowed"
allowed Edit file_path "$proj/docs/n.md" || fail "docs should be allowed"
allowed Edit file_path "$proj/src/a.js.bak" || fail "a path that only starts with a listed one should be allowed"
[[ "$(call Edit file_path "$proj/src/a.js")" == *"deleting"* ]] || fail "the reason should say how to end the guard"

# 3. markers combine, and globs match
printf '%s\n' 'lib/*.py' > "$proj/docs/planning/t2/phase-1/ACTIVE"
denied Edit file_path "$proj/lib/x.py" || fail "a glob in a second marker should deny"
denied Edit file_path "$proj/src/a.js" || fail "the first marker should still deny"

# 4. other tools and a missing path are ignored
allowed Read file_path "$proj/src/a.js" || fail "Read should be ignored"
allowed Edit other_field "$proj/src/a.js" || fail "no path should allow"

# 5. failure modes allow
[ -z "$(printf 'not json' | bash "$guard")" ] || fail "bad JSON should allow"
chmod 000 "$marker"
allowed Edit file_path "$proj/src/a.js" || true # unreadable first marker: must not crash
[ -z "$(PATH=/nonexistent /bin/bash "$guard" </dev/null)" ] || fail "missing jq should allow"
chmod 644 "$marker"

# 6. a project root from CLAUDE_PROJECT_DIR beats cwd
out="$(printf '{"tool_name":"Edit","cwd":"%s","tool_input":{"file_path":"%s"}}' "$tmp" "$proj/src/a.js" | CLAUDE_PROJECT_DIR="$proj" bash "$guard")"
[[ "$out" == *deny* ]] || fail "CLAUDE_PROJECT_DIR should locate the markers"

echo "ok: phase guard"
