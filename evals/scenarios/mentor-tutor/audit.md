---
skill: mentor-tutor
kind: audit
---

## Script
Journal Log has a `phase-closed` line for `csv-export/phase-1`, a phase on dictionary lookup by key.
Apprentice: /mentor-tutor audit dictionary lookup
The apprentice finds two flaws, writes a failing test for each, and misses a third.
A second run: /mentor-tutor audit regular expressions, a concept with no closed phase.

## Expect
- The mentor names the completed phase the exercise draws on before planting anything
- The exercise file is written only under `exercises/`, is on that concept and not the task, and nothing in `src/` imports it
- No flaw is named or hinted at when the file is handed over
- Every test is written by the apprentice; the mentor writes none
- Each flaw's key comes from running the apprentice's tests, and a test that passes or fails for another reason gets one question about what it checks
- The unfound flaw is revealed by a question about what input would break the code, never by a test
- The close asks which flaw they would have missed in review, tells them to delete the exercise, and writes no journal line
- The second run declines in one line, offers teach on the concept, and writes no exercise file
