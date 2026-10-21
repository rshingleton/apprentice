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
| **Hint ladder** | The three escalating levels of help: Concept, Pseudocode, Decomposition. |
| **Comprehension gate** | The single conceptual question `/mentor-review` asks before a phase closes. |
| **Learner journal** | The apprentice's personal, append-only record at `~/.apprentice/journal.md` (or `$APPRENTICE_JOURNAL`): a Profile of their experience and prior knowledge, then one line per event. Never committed. |
| **Hint log** | The `hint` and `phase-closed` lines of the learner journal: each hint's level, phase and topic, and the hints a phase closed with. |
| **Deep module** | A module whose small, stable interface hides substantial internal complexity. |
| **Routing case** | A sample request in `evals/routing.tsv` with the trigger phrase that must route it to one skill's description and no other. |
| **Scenario** | A scripted apprentice exchange in `evals/scenarios/` with the behaviour the mentor must and must not show. |
| **Accordion model** | Expand detail in `docs/planning/{ID}/`, focus in the active file, then compress to an archive and ADRs. |
