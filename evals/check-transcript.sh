#!/usr/bin/env bash
# One-question-per-turn check for a transcript of "Apprentice:" and "Mentor:" turns.
#
#   evals/check-transcript.sh <transcript.md>
#
# A turn starts at a line beginning "Mentor:" or "Apprentice:" and runs to the next one.
# Fenced and inline code are ignored, and an unclosed fence fails. A question is a "?" followed by
# whitespace, a closing quote, bracket or emphasis mark, or the end of the line. Exits 1 if any Mentor turn has more than one.
set -euo pipefail

[ $# -eq 1 ] && [ -f "$1" ] || { echo "usage: $0 <transcript.md>" >&2; exit 2; }

awk -v file="$1" '
  function flush() { if (who == "Mentor" && q > 1) { printf "FAIL %s: Mentor turn %d (line %d) asks %d questions\n", file, turn, start, q; bad = 1 } }
  /^[ \t]*```/ { fence = !fence; next }
  fence { next }
  /^(Mentor|Apprentice):/ { flush(); who = substr($0, 1, index($0, ":") - 1); turn++; start = NR; q = 0 }
  {
    line = $0
    gsub(/`[^`]*`/, "", line)
    while (match(line, /\?([ \t"'"'"')\]}*_]|$)/)) { q++; line = substr(line, RSTART + RLENGTH) }
  }
  END { flush(); if (fence) { printf "FAIL %s: unclosed code fence\n", file; bad = 1 } exit bad }
' "$1"
