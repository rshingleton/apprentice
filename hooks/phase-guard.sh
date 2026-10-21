#!/usr/bin/env bash
# PreToolUse hook: denies the AI's edits to the paths listed in an active phase marker.
#
# A marker is docs/planning/{ID}/phase-N/ACTIVE: one path or glob per line, relative
# to the project root (a directory needs a glob: src/*); blank lines and lines
# starting with # are ignored. Markers
# found are combined, and are themselves protected. Anything else is allowed, and
# any failure allows the call: this guard never blocks work by breaking.
#
# Tool input fields: Edit and Write carry file_path, NotebookEdit carries
# notebook_path (both seen in a live session). MultiEdit does not exist in the
# build tested; it is read as file_path, unconfirmed.
#
# shortcut: paths are matched as given, with no ../ or symlink normalisation, and
# Bash writes are not seen; upgrade if a bypass is found in practice.
set -uo pipefail
trap 'exit 0' ERR

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
tool="$(jq -r '.tool_name // empty' <<<"$input" 2>/dev/null)" || exit 0
case "$tool" in Edit | Write | MultiEdit | NotebookEdit) ;; *) exit 0 ;; esac
target="$(jq -r '.tool_input.file_path // .tool_input.notebook_path // empty' <<<"$input" 2>/dev/null)" || exit 0
[ -n "$target" ] || exit 0

root="${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null)}"
[ -n "$root" ] || exit 0
root="${root%/}"
rel="${target#"$root"/}"

deny() {
  jq -nc --arg r "$1" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: $r}}'
  exit 0
}

shopt -s nullglob
for marker in "$root"/docs/planning/*/phase-*/ACTIVE; do
  [ "$target" = "$marker" ] && deny "The phase guard protects its own marker: $marker. The apprentice ends the guard by deleting it."
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%$'\r'}"
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    case "$line" in '' | '#'*) continue ;; esac
    # shellcheck disable=SC2254 # the marker's line is a glob on purpose
    case "$rel" in $line) deny "$rel is production code for the active phase (listed in ${marker#"$root"/}). The apprentice writes it. You may edit tests, exercises and docs. The apprentice ends the guard by deleting the marker." ;; esac
  done < <(cat "$marker" 2>/dev/null)
done
exit 0
