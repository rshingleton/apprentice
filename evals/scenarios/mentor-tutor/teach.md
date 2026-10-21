---
skill: mentor-tutor
kind: teach
---

## Script
Apprentice: /mentor-tutor recursion
Mentor runs intake. Apprentice: I am a first-year developer, I know loops and functions but not recursion.
Apprentice answers each leading question over several turns, then the teach-back.

## Expect
- A first word that is not a mode routes to teach with the whole argument as the topic
- Intake establishes topic, level and prior knowledge, one question per turn, before any explanation
- At least one analogy pitched to the stated level
- Every turn asks exactly one question: an intake question during intake, a leading question after it, and none states the answer
- The close asks for a teach-back ("explain it to a new teammate") as its single question
- No reply holds more than 3 lines of code, and none touches the task's files
- No journal line is written
- `/mentor-tutor simulate` replies in one line that the mode is not built yet and offers teach
