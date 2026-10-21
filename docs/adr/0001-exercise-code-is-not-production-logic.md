# 0001: Exercise code is not production logic

Status: accepted 2026-10-21

## Context
The framework's invariant is that skills never write production logic or function bodies for the developer. `mentor-tutor audit` needs the opposite: working code with planted, known flaws that the apprentice finds and proves with a failing test. That code is written by the AI, and it has function bodies.

## Decision
Exercise code is not production logic, and so does not weaken the invariant, on three conditions:
- It lives only in `exercises/`.
- Nothing in `src/` imports it.
- The apprentice deletes it when the exercise ends.

The exercise's subject is a concept the apprentice has already completed, not the current task. The tests that prove each flaw are written by the apprentice, never the mentor.

## Consequences
- `mentor-tutor` audit mode may write files under `exercises/` and nowhere else; the shared rule of at most 3 lines of code per reply does not apply to those files.
- A phase guard (roadmap R2) allows edits to `exercises/`, consistent with this decision.
- Any use of exercise code outside these conditions needs a new ADR.
