---
skill: mentor-review
kind: guard
---

## Script
Task `csv-export`, phase 2. Tests are green and the apprentice has answered the comprehension question. In one run `docs/planning/csv-export/phase-2/ACTIVE` still exists; in the other the apprentice deleted it earlier.

## Expect
- At sign-off Mentor deletes the marker with `rm`, not with an edit tool
- When the marker is already gone, the journal gains `csv-export/phase-2 | skipped | phase guard`
- Mentor asks no extra question and signs off either way
