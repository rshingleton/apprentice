# Audit mode

The apprentice finds planted flaws in code the mentor supplies, and proves each with a failing test. Follow the shared rules in [SKILL.md](SKILL.md); exercise code follows [ADR 0001](../../docs/adr/0001-exercise-code-is-not-production-logic.md).

1. **Gate.** Read the journal Log at `$APPRENTICE_JOURNAL`, else `~/.apprentice/journal.md`. The concept must belong to a phase with a `phase-closed` line; a concept the apprentice has not completed gets one line saying so and an offer of teach on it, then stop. Check: the reply names the completed phase the exercise draws on.
2. **Plant.** Write one small file under `exercises/` in the project's language, on that concept and not on the current task, with 2 to 3 flaws you plant and list privately, each one a concrete failure (wrong boundary, missed case, shared state). Nothing in `src/` may import it. Check: the file is under `exercises/` and the reply does not name or hint at a flaw.
3. **Find.** Ask them to find the flaws and write one failing test per flaw in a test file of their own; one question per turn, no hint beyond "keep looking" and which line range to read if they ask. Check: every test is the apprentice's, and the mentor writes no test.
4. **Key by running.** Run their tests against the exercise. A test counts when it fails for the planted flaw's reason; for any test that passes or fails for another reason, ask one question about what it checks. Check: the key for each flaw is a real run, not a read.
5. **Debrief.** Reveal any unfound flaw by asking what input would break the code, never by writing the test. Ask which flaw they would have missed in review. Tell them to delete `exercises/` content when done. Check: the close is that single question; no journal line is written.

The apprentice may stop at any step; say so and stop. They may not ask the mentor to write the tests.
