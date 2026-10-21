# Apprentice context

Domain terms used across the skills and docs.

| Term | Meaning |
|------|---------|
| **Apprentice** | The junior developer using the framework. Also the name of the framework. |
| **Mentor** | The AI in its coaching role. It plans, scaffolds, hints, diagnoses and reviews; it does not write production logic. |
| **Grill** | The planning interview: one question at a time, to refine the apprentice's mental model. |
| **Vertical slice** | An independently testable phase that touches the data path end to end. |
| **Task brief** | `phase-N/task-brief.md`: interface boundaries, expected behaviour, acceptance criteria, likely misconceptions and non-goals for one phase. |
| **Scaffold** | The generated test harness, fixtures, mocks and interface stubs for a phase. |
| **Red** | The state where the new test suite fails cleanly because the logic is missing. |
| **Stub** | A typed signature with a docstring and pseudocode whose body throws an unimplemented error. |
| **Hint ladder** | The escalating levels of help: three of AI help (Concept, Pseudocode, Decomposition), then Level 4, a handoff to a human. |
| **Handoff brief** | The Level 4 note for a human senior: Goal, Tried, Hints used and The question. It holds no solution code. |
| **Comprehension gate** | The single conceptual question `/mentor-review` asks before a phase closes. With a weak spot it is a teach-back on that topic. |
| **Weak spot** | The topic the apprentice needed the most help with, read from the learner journal: the highest-level hint for the phase, else the most-hinted topic, ties to the most recent. |
| **Teach-back** | The closing question phrased as "explain it to a new teammate", so the apprentice shows understanding in their own words. |
| **Learner journal** | The apprentice's personal, append-only record at `~/.apprentice/journal.md` (or `$APPRENTICE_JOURNAL`): a Profile of their experience and prior knowledge, then one line per event. Never committed. |
| **Hint log** | The `hint` and `phase-closed` lines of the learner journal: each hint's level, phase and topic, and the hints a phase closed with. |
| **Tutor mode** | One of teach, quiz, challenge, audit or simulate: a file inside `mentor-tutor` chosen by the first word of `/mentor-tutor <mode> [topic]`. Teach is the default; all five are built. |
| **Phase guard** | The plugin's PreToolUse hook, `hooks/phase-guard.sh`: it denies the mentor's Edit, Write, MultiEdit and NotebookEdit on the paths in a phase marker. A guard, not a wall: Bash writes and `disableAllHooks` bypass it. |
| **Phase marker** | `docs/planning/{ID}/phase-N/ACTIVE`: one path or glob per line, written by `/mentor-scaffold` seeded with the stub, deleted by `/mentor-review` at sign-off or by the apprentice to end the guard early. Gitignored; itself protected by the guard. |
| **Deep module** | A module whose small, stable interface hides substantial internal complexity. |
| **Routing case** | A sample request in `evals/routing.tsv` with the trigger phrase that must route it to one skill's description and no other. |
| **Scenario** | A scripted apprentice exchange in `evals/scenarios/` with the behaviour the mentor must and must not show. |
| **Accordion model** | Expand detail in `docs/planning/{ID}/`, focus in the active file, then compress to an archive and ADRs. |
