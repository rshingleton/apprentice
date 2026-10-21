---
title: Apprentice deepening
approved: 2026-10-21
---

# Apprentice deepening

## Destination
An apprentice using the framework is kept from outsourcing their thinking. The "AI writes no production logic" rule is enforced by the tool, not only by a prompt. Each stage trains a thinking habit and names its own limits, the framework remembers what the apprentice struggled with, a stuck apprentice reaches a human, and one new skill, `mentor-tutor`, carries the practice the core loop does not as modes (teach, quiz, challenge, audit, simulate), so the framework grows from five skills to six, not ten. Research basis: [docs/research/learning-sources.md](../research/learning-sources.md).

- G1: The invariant is mechanically enforced: during an active phase the AI cannot edit production source, only tests, stubs, exercises and docs.
- G2: Apprentices practise predicting outcomes and designing test cases before the AI does it for them.
- G3: A stuck apprentice gets a concept tutor, and past Hint Level 3 (a new Level 4) a brief a human senior can act on.
- G4: Hint use, level and recurring mistakes are recorded and shape the review question.
- G5: The loop has a guided refactor beat and structured feedback (goal, feedback, next step) with a revise-and-resubmit pass.
- G6: Every skill is covered by evals, including adversarial scenarios (asking for the answer, making the typical mistake) and one-question-per-turn checks.
- G7: Planning teaches reuse-before-write and an AI-versus-manual choice, and the apprentice authors the criteria and the pre-mortem.
- G8: Every skill states its pedagogy, its risks and how the apprentice stays in charge, from one shared anatomy.
- G9: The apprentice practises critical evaluation of AI output and challenge of their own decisions, with answers checkable by running code.
- G10: The tutor's explanations are grounded in verified local reference cards that cite primary sources, so it cites a card or admits a gap instead of improvising.

## Milestones

### M1: Enforce the invariant
Exit: with an active phase, an attempted AI edit to a production file is denied and an edit to its test file is allowed, shown in a recorded session.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R1 | spike | Can a Claude Code hook deny edits by path using a phase marker? | G1 | none | Answer recorded in an ADR; throwaway code removed | high | |
| R2 | build | Phase-guard hook shipped in the plugin | G1 | R1 (feasibility), D1 (marker, production-path rule) | Active phase: edit to `src/` denied, to the test file and `exercises/` allowed; no phase: edits allowed | high | |

### M2: Make them think
Exit: a scripted run of the sample kata shows the predict prompt, the case-listing prompt, a three-part review with a revise pass, and the evals pass.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R3 | enabler | `evals/`: routing cases for every skill description, scripted scenarios (ask for the answer, typical mistake, great/middling/poor submission), a one-question-per-turn check | G6 | none | Eval command exits 0 on current skills; non-zero on a broken description or a transcript with two questions in one turn | med | shipped 2026-10-21 evals-harness |
| R4 | build | Skill anatomy in `AGENTS.md`, following `write-a-skill` from rshingleton/skills (third-person description with "Use when", under 100 lines, Quick start, Workflows, Advanced links one level deep) plus role, steps ending on a check, pedagogy, risks and apprentice in charge; a rule that a new mode is a file inside an existing skill, not a new skill, unless it has its own trigger; applied to the five skills; README Limits (privacy: no secrets or proprietary code where policy forbids) and Credits | G8 | R3 (structure check), D6 (what the apprentice may skip) | Eval structure check finds the pedagogy, risks and apprentice-in-charge sections in every skill, each `SKILL.md` under 100 lines and each description containing "Use when"; README has Limits and Credits | low | |
| R5 | build | Predict-before-run in `mentor-scaffold` (Red) and `mentor-diagnose` (before instrumenting) | G2 | R3 (evals) | Scenario transcript has a prediction question before the first run | low | shipped 2026-10-21 predict-before-run |
| R6 | build | Test-case ownership in `mentor-scaffold`: apprentice lists edge cases first and writes at least one test | G2 | R3 (evals), D2 (how much to hand over) | Scenario shows the apprentice's cases requested and the AI adding only the missing ones | med | |
| R7 | build | `mentor-review`: guided refactor after green; feedback as goal, feedback, next step, with an on-track call; revise-and-resubmit with a before/after comparison | G5 | R3 (evals) | Scenario with a poor submission: three-part feedback, a revise request, second pass compares versions; no AI-written code | med | |
| R8 | build | `mentor-plan` habits: reuse ladder, stated assumptions, AI-versus-manual choice, apprentice-authored criteria, pre-mortem table holding only the apprentice's words | G7 | R3 (evals) | Scenario shows the reuse questions asked, the AI critiquing not writing the criteria, and a pre-mortem table with no AI text | low | |
| R9 | build | Task brief gains "Likely misconceptions"; `mentor-hint` targets a listed one at Level 1 | G2 | R3 (evals) | Scenario where the apprentice makes a listed mistake: Level 1 hint names the concept, not the fix | med | |

### M3: Remember and escalate
Exit: after a scripted phase with two hints, the tutor cites a reference card for a concept, the journal records them with the apprentice's level, review asks a question tied to them and closes with a teach-back, `mentor-tutor` teaches a concept without solving the task, and `mentor-hint` Level 4 produces a brief.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R10 | build | Hint log and learner journal (level, prior knowledge, hints per phase, unaided debugging, explain-the-diff answers) written by `mentor-hint` and `mentor-review` | G4 | R3 (evals), D3 (location, committed or not) | After two hints in a scenario the journal lists both with level and phase | med | |
| R11 | build | Review uses the journal: "what I did not check" line, a question aimed at the recorded weak spot, teach-back gate ("explain it to a new teammate"), a short reflection | G4 | R10 (journal), R7 (review structure) | Scenario's closing question references a journaled hint and asks for a teach-back | low | |
| R12 | build | `mentor-hint` Level 4, human handoff: a brief for a human senior (goal, tried, hints used, the question), offered after Level 3 fails | G3 | R10 (hint log) | Scenario that fails Level 3 ends in a brief with the four parts and no solution code | low | |
| R13 | build | `mentor-tutor` core: a router (`/mentor-tutor <mode> [topic]` with mode one of teach, quiz, challenge, audit or simulate; default teach), the shared rules in `SKILL.md`, and `TEACH.md`: intake (topic, level, prior knowledge), analogies pitched to level, a leading question each turn, teach-back close; concepts only | G3 | R3 (evals), R10 (level profile), D4 (where explaining ends) | Asked for the task's answer it declines and asks a leading question; the typical-mistake scenario is corrected by a question; at most 3 lines of code per reply; each mode argument routes to its own file | med | |
| R18 | build | Reference cards in `skills/mentor-tutor/references/`: an index plus about ten cards (complexity and data-structure choice, testing and test doubles, naming and small functions, error handling, debugging method, HTTP and REST basics, SQL basics, git workflow, OOP versus functional, security basics). Each card: summary in our own words, primary sources, 3-4 misconceptions, 2-3 check questions, last-verified date. `TEACH.md` cites a card or says the topic is not covered | G10 | R13 (tutor core), R3 (evals), D7 (topics and verifier) | Eval check: every card has sources, a verified date and stays under 40 lines; scenario on a covered topic cites the card, on an uncovered topic says it is not in the references | med | |

### M4: Practise and challenge
Exit: a scripted session runs each tutor mode (quiz, challenge, audit, simulate) once and the evals pass. No new skill directory is added in this milestone.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R14 | build | Tutor mode `QUIZ.md`: retrieval questions seeded from the journal, on the apprentice's own code, with predict-the-output questions whose key is checked by running the code | G9 | R13 (tutor router), R10 (journal) | Every predict-the-output key matches the code's real output in a scenario run; feedback explains each answer | med | |
| R15 | build | Tutor mode `CHALLENGE.md`: devil's advocate and prospective hindsight on a plan or design, questions only; the apprentice must accept or reject each mentor or AI suggestion with a reason | G9 | R13 (tutor router) | Scenario transcript has only questions from the mentor, never an answer, and a recorded accept or reject with reason for each suggestion | med | |
| R16 | build | Tutor mode `AUDIT.md`: the AI supplies exercise code with planted, known flaws in `exercises/`; the apprentice finds each and proves it with a failing test; gated to concepts the apprentice has already completed | G9 | R13 (tutor router), R10 (journal), D5 (exercise code and the invariant) | Each planted flaw has a failing test written by the apprentice; the key is checked by running them | high | |
| R17 | build | Tutor mode `SIMULATE.md`: engineering scenarios (stakeholder clarification, production incident, hostile code review); the mentor never plays the apprentice; a consequential choice after four exchanges; a debrief that asks which concept was applied | G9 | R13 (tutor router), R10 (journal) | Scenario shows the mentor playing only other roles, the choice after four exchanges, and the debrief question | med | |

## Open decisions
- D1: What is a production path, and where does the active-phase marker live (a file in `docs/planning/{ID}/`, or the task brief)? `exercises/` and test files are allowed. Answer by: R1 spike, then grill. Blocks R2.
- D2: Does test-case ownership hand over gradually with progress, or is it fixed at "list cases, write one"? Recommended: fixed at first. Answer by: grill. Blocks R6.
- D3: Is the learner journal committed or gitignored and personal? Recommended: gitignored, with an opt-in to commit. Answer by: grill. Blocks R10.
- D4: Where does explaining a concept end and leaking a solution begin? Recommended: concepts and general patterns only, never this task's logic. Answer by: grill. Blocks R13.
- D5: Does AI-supplied exercise code count as production logic under the invariant? Recommended: no, if it lives only in `exercises/`, is never imported by `src/`, and is deleted after the exercise. Answer by: grill, then an ADR. Blocks R16.
- D6: Which steps may the apprentice skip or end ("you're in charge")? Recommended: process steps are skippable and the skip is journaled; test integrity and the comprehension gate are not. Answer by: grill. Blocks R4.

- D7: Which topics come first, and who verifies each card against its primary source? Recommended: the owner picks the ten from the team's common review comments; the AI drafts with `look-it-up`; the owner spot-checks before a card is marked verified. Answer by: grill. Blocks R18.

## Fog
- Help budgets and AI-tool graduation that widen with demonstrated progress (needs R10 and its metrics).
- A code-reading exercise before editing an unfamiliar module.
- A retro at epic close.
- Team modes for team leads: skill mapping to tasks, team structure.
- A per-model reliability check of the skills, since the paper reports prompts working on some models and not others.

## Out of scope
- Scoring or ranking apprentices, and any telemetry.
- Hosts other than Claude Code.
- Further top-level skills: a new mode is a file inside an existing skill unless it has its own trigger.
- The installer (tracked as its own item, `add-installer`).

## Decisions so far
- 2026-10-21 Decision: reference material is link-first cards in our own words, not copied tutorials; a card is verified against a primary source before use.
- 2026-10-21 Decision: keep mentor output explanatory, not terse; borrow only word caps for internal agent reports.
- 2026-10-21 Decision: ideas from the credited sources are rewritten in this repo's own words and credited in the README; prompt text is not copied. The paper calls its approaches largely untested, so each new skill ships with evals.

- 2026-10-21 Decision: six skills, not ten. `mentor-tutor` holds teach, quiz, challenge, audit and simulate as sibling files behind one description; the human handoff is Level 4 of `mentor-hint`. Skills follow `write-a-skill` from rshingleton/skills (the copy in that repo; a differing copy sits in cmdb-mcp).

## Changes
- 2026-10-21: roadmap drafted from the credited-repo review.
- 2026-10-21: replanned after reading the Mollick paper and the prompts-for-edu prompts: added R4 (skill anatomy), R9 (misconceptions), M4 (quiz, challenge, audit, simulate), D5, D6; reshaped R7, R8, R11 and `mentor-tutor` (R13).
- 2026-10-21: added R18 (reference cards for the tutor), G10 and D7.
- 2026-10-21: consolidated to avoid sprawl: R14-R17 became tutor modes blocked by R13; R12 became hint Level 4; R4 adopts the write-a-skill conventions.
- 2026-10-21: R3 shipped as `evals-harness`: `evals/run.sh` and `evals/test-evals.sh`; scenarios are structure-checked only, not run against a model.
- 2026-10-21: R5 shipped as `predict-before-run`: `mentor-scaffold` and `mentor-diagnose` ask for a prediction before the first run; `predict` scenarios are required for both.
