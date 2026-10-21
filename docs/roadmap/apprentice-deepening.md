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

## Milestones

### M1: Enforce the invariant
Exit: with an active phase, an attempted AI edit to a production file is denied and an edit to its test file is allowed, shown in a recorded session.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R1 | spike | Can a Claude Code hook deny edits by path using a phase marker? | G1 | none | Answer recorded in an ADR; throwaway code removed | high | shipped 2026-10-21 phase-guard-spike |
| R2 | build | Phase-guard hook shipped in the plugin | G1 | R1 (feasibility), D1 (marker, production-path rule) | Active phase: edit to `src/` denied, to the test file and `exercises/` allowed; no phase: edits allowed | high | |

### M2: Make them think
Exit: a scripted run of the sample kata shows the predict prompt, the case-listing prompt, a three-part review with a revise pass, and the evals pass.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R3 | enabler | `evals/`: routing cases for every skill description, scripted scenarios (ask for the answer, typical mistake, great/middling/poor submission), a one-question-per-turn check | G6 | none | Eval command exits 0 on current skills; non-zero on a broken description or a transcript with two questions in one turn | med | shipped 2026-10-21 evals-harness |
| R4 | build | Skill anatomy in `AGENTS.md`, following `write-a-skill` from rshingleton/skills (third-person description with "Use when", under 100 lines, Quick start, Workflows, Advanced links one level deep) plus role, steps ending on a check, pedagogy, risks and apprentice in charge; a rule that a new mode is a file inside an existing skill, not a new skill, unless it has its own trigger; applied to the five skills; README Limits (privacy: no secrets or proprietary code where policy forbids) and Credits | G8 | R3 (structure check), D6 (what the apprentice may skip) | Eval structure check finds the pedagogy, risks and apprentice-in-charge sections in every skill, each `SKILL.md` under 100 lines and each description containing "Use when"; README has Limits and Credits | low | shipped 2026-10-21 skill-anatomy |
| R5 | build | Predict-before-run in `mentor-scaffold` (Red) and `mentor-diagnose` (before instrumenting) | G2 | R3 (evals) | Scenario transcript has a prediction question before the first run | low | shipped 2026-10-21 predict-before-run |
| R6 | build | Test-case ownership in `mentor-scaffold`: apprentice lists edge cases first and writes at least one test | G2 | R3 (evals) | Scenario shows the apprentice's cases requested and the AI adding only the missing ones | med | shipped 2026-10-21 test-case-ownership |
| R7 | build | `mentor-review`: guided refactor after green; feedback as goal, feedback, next step, with an on-track call; revise-and-resubmit with a before/after comparison | G5 | R3 (evals) | Scenario with a poor submission: three-part feedback, a revise request, second pass compares versions; no AI-written code | med | shipped 2026-10-21 guided-review |
| R8 | build | `mentor-plan` habits: reuse ladder, stated assumptions, AI-versus-manual choice, apprentice-authored criteria, pre-mortem table holding only the apprentice's words | G7 | R3 (evals) | Scenario shows the reuse questions asked, the AI critiquing not writing the criteria, and a pre-mortem table with no AI text | low | shipped 2026-10-21 planning-habits |
| R9 | build | Task brief gains "Likely misconceptions"; `mentor-hint` targets a listed one at Level 1 | G2 | R3 (evals) | Scenario where the apprentice makes a listed mistake: Level 1 hint names the concept, not the fix | med | shipped 2026-10-21 likely-misconceptions |

### M3: Remember and escalate
Exit: after a scripted phase with two hints, the journal records them with the apprentice's level, review asks a question tied to them and closes with a teach-back, `mentor-tutor` teaches a concept without solving the task, and `mentor-hint` Level 4 produces a brief.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R10 | build | Hint log and learner journal (level, prior knowledge, hints per phase, unaided debugging, explain-the-diff answers) written by `mentor-hint` and `mentor-review` | G4 | R3 (evals), D3 (location, committed or not) | After two hints in a scenario the journal lists both with level and phase | med | shipped 2026-10-21 learner-journal |
| R11 | build | Review uses the journal: "what I did not check" line, a question aimed at the recorded weak spot, teach-back gate ("explain it to a new teammate"), a short reflection | G4 | R10 (journal), R7 (review structure) | Scenario's closing question references a journaled hint and asks for a teach-back | low | shipped 2026-10-21 review-uses-journal |
| R12 | build | `mentor-hint` Level 4, human handoff: a brief for a human senior (goal, tried, hints used, the question), offered after Level 3 fails | G3 | R10 (hint log) | Scenario that fails Level 3 ends in a brief with the four parts and no solution code | low | shipped 2026-10-21 hint-handoff |
| R13 | build | `mentor-tutor` core: a router (`/mentor-tutor <mode> [topic]` with mode one of teach, quiz, challenge, audit or simulate; default teach), the shared rules in `SKILL.md`, and `TEACH.md`: intake (topic, level, prior knowledge), analogies pitched to level, a leading question each turn, teach-back close; concepts only | G3 | R3 (evals), R10 (level profile), D4 (where explaining ends) | Asked for the task's answer it declines and asks a leading question; the typical-mistake scenario is corrected by a question; at most 3 lines of code per reply; each mode argument routes to its own file | med | shipped 2026-10-21 tutor-core |

### M4: Practise and challenge
Exit: a scripted session runs each tutor mode (quiz, challenge, audit, simulate) once and the evals pass. No new skill directory is added in this milestone.

| Slice | Kind | Delivers | Covers | Blocked by | Verify | Risk | Status |
|-------|------|----------|--------|------------|--------|------|--------|
| R14 | build | Tutor mode `QUIZ.md`: retrieval questions seeded from the journal, on the apprentice's own code, with predict-the-output questions whose key is checked by running the code | G9 | R13 (tutor router), R10 (journal) | Every predict-the-output key matches the code's real output in a scenario run; feedback explains each answer | med | shipped 2026-10-21 tutor-quiz |
| R15 | build | Tutor mode `CHALLENGE.md`: devil's advocate and prospective hindsight on a plan or design, questions only; the apprentice must accept or reject each mentor or AI suggestion with a reason | G9 | R13 (tutor router) | Scenario transcript has only questions from the mentor, never an answer, and a recorded accept or reject with reason for each suggestion | med | shipped 2026-10-21 tutor-challenge |
| R16 | build | Tutor mode `AUDIT.md`: the AI supplies exercise code with planted, known flaws in `exercises/`; the apprentice finds each and proves it with a failing test; gated to concepts the apprentice has already completed | G9 | R13 (tutor router), R10 (journal), D5 (exercise code and the invariant) | Each planted flaw has a failing test written by the apprentice; the key is checked by running them | high | shipped 2026-10-21 tutor-audit |
| R17 | build | Tutor mode `SIMULATE.md`: engineering scenarios (stakeholder clarification, production incident, hostile code review); the mentor never plays the apprentice; a consequential choice after four exchanges; a debrief that asks which concept was applied | G9 | R13 (tutor router), R10 (journal) | Scenario shows the mentor playing only other roles, the choice after four exchanges, and the debrief question | med | shipped 2026-10-21 tutor-simulate |

## Open decisions
- D1: What is a production path, and where does the active-phase marker live (a file in `docs/planning/{ID}/`, or the task brief)? `exercises/` and test files are allowed. Answer by: R1 spike, then grill. Blocks R2.
- D2: Does test-case ownership hand over gradually with progress, or is it fixed at "list cases, write one"? Answered 2026-10-21: fixed at "list cases, write one" for now; gradual handover waits for the journal (R10). Blocks R6 (now unblocked).


## Fog
- Ground the tutor's explanations in local material instead of the model's memory: first the repo's own mapped code (`map-it`, `docs/reference/`) where it holds similar concepts, else common patterns tied to the work at hand. The earlier idea of verified reference cards with primary-source citations (about ten, with a verifier) is parked here, to revisit once the tutor shows where it gets things wrong.
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
- 2026-10-21: R9 shipped as `likely-misconceptions`: task briefs list likely misconceptions; `mentor-hint` Level 1 names a matching concept, not the fix; `misconception` scenario required for `mentor-hint`.
- 2026-10-21: R6 shipped as `test-case-ownership`: `mentor-scaffold` asks for the apprentice's edge cases, has them write at least one test, and adds only the missing cases; `cases` scenario required for `mentor-scaffold`.
- 2026-10-21: R7 shipped as `guided-review`: `mentor-review` adds a guided refactor after green, Goal/Feedback/Next step feedback with an on-track call, and revise-and-resubmit with a before/after comparison; the `poor` scenario now covers the revise pass.
- 2026-10-21: R8 shipped as `planning-habits`: `mentor-plan` asks the reuse, assumption and AI-versus-manual questions, has the apprentice author the acceptance criteria, and adds a pre-mortem table of only the apprentice's words; `habits` scenario required for `mentor-plan`.
- 2026-10-21 Decision (D6): process steps are skippable and the skip is journaled once R10 exists; test integrity and the comprehension gate are not skippable. Unblocks R4.
- 2026-10-21: R4 shipped as `skill-anatomy`: `AGENTS.md` documents the skill anatomy and the new-mode rule; `evals/run.sh` checks each skill's "Use when" description, length and Pedagogy, Risks and Apprentice in charge sections; README gains Limits and Credits.
- 2026-10-21 Decision (D3): the learner journal is never committed. It lives in a gitignored location, either at the skill's base directory or under `$HOME`; R10 picks the default and the lookup order. Unblocks R10.
- 2026-10-21: R10 shipped as `learner-journal`: `mentor-hint` logs each hint and asks for the apprentice's experience once; `mentor-review` records the phase's hint count, the explained answer and a skipped guided refactor; the format and path (`$APPRENTICE_JOURNAL`, else `~/.apprentice/journal.md`) live in `skills/mentor-hint/JOURNAL.md`; `journal` scenarios required for hint and review. Other skills do not write the journal yet.
- 2026-10-21: R11 shipped as `review-uses-journal`: `mentor-review` reads the learner journal, states a "Did not check" line, and makes its single closing question a teach-back on the apprentice's weak spot (generic question as the fallback); the sign-off invites an optional one-line reflection, not journaled; `teach-back` scenario required for `mentor-review`.
- 2026-10-21 Decision (D4): the tutor explains concepts and general patterns only, never this task's logic. Unblocks R13.
- 2026-10-21 Decision (D5): AI-supplied exercise code does not count as production logic, on the recommended terms: it lives only in `exercises/`, is never imported by `src/`, and is deleted after the exercise. R16 records this in an ADR. Unblocks R16.
- 2026-10-21 Decision (D7): R18, the reference cards, and G10 are deferred to Fog. The tutor explains concepts and general patterns (D4); where it needs grounding it uses the repo's own mapped code, else common patterns related to the work at hand. This supersedes the earlier link-first-cards decision for now.
- 2026-10-21: R18 and D7 removed from M3 and Open decisions; G10 moved to Fog; the M3 exit no longer mentions a reference card.
- 2026-10-21: R12 shipped as `hint-handoff`: `mentor-hint` Level 4 offers, after Level 3 is tried, a brief for a human senior (Goal, Tried, Hints used, The question) with no solution code, printed in chat and not journaled; `handoff` scenario required for `mentor-hint`.
- 2026-10-21: R13 shipped as `tutor-core`: `mentor-tutor` is the sixth skill, with a `/mentor-tutor <mode> [topic]` router (teach by default), `TEACH.md`, and placeholders for quiz, challenge, audit and simulate; `teach` scenario and the five mode files required for `mentor-tutor`.
- 2026-10-21: R14 shipped as `tutor-quiz`: `/mentor-tutor quiz` seeds 3 to 5 one-at-a-time questions from the journal Log and the apprentice's own code, takes every predict-the-output key from a real run, and explains each answer; `quiz` scenario required for `mentor-tutor`.
- 2026-10-21: R15 shipped as `tutor-challenge`: `/mentor-tutor challenge` asks devil's-advocate and prospective-hindsight questions on the apprentice's plan, never answers, and records each accept or reject with the apprentice's reason in a chat table; `challenge` scenario required for `mentor-tutor`.
- 2026-10-21: R16 shipped as `tutor-audit`: `/mentor-tutor audit` is gated to concepts from a `phase-closed` phase, plants 2 to 3 flaws in `exercises/`, has the apprentice prove each with a failing test of their own, and checks the key by running; ADR 0001 records D5; `audit` scenario required for `mentor-tutor`.
- 2026-10-21: R1 shipped as `phase-guard-spike`: ADR 0002 records that a plugin PreToolUse hook can deny production-path edits while a phase marker exists (checked by script and in a live session, bypass mode included), with limits: Bash writes bypass an Edit matcher, `disableAllHooks` turns the guard off, `MultiEdit` and `NotebookEdit` inputs untested. D1 now also asks how the hook finds the active phase and who owns the marker.
- 2026-10-21: R17 shipped as `tutor-simulate`: `/mentor-tutor simulate` role-plays a stakeholder, incident or hostile-review scenario with the mentor in only the other roles, a consequential choice after four exchanges, and a debrief asking which concept was applied; `simulate` scenario required for `mentor-tutor`. All five tutor modes are built; M4 is complete.
