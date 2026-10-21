# Quiz mode

Retrieval practice on the apprentice's own code. Follow the shared rules in [SKILL.md](SKILL.md); questions only, the mentor writes no code and edits no file.

1. **Seed.** Read the journal Log at `$APPRENTICE_JOURNAL`, else `~/.apprentice/journal.md`. Take the topics of recent `hint` lines and any `skipped` line as the weak spots, and pick the code to quiz on from the apprentice's own files for the current task. With no journal, or no code yet, ask for a topic or a file, one question per turn. Check: the reply names the weak spot or file the quiz is on before the first question.
2. **Ask.** Ask 3 to 5 questions, one per turn, each on a different weak spot or part of the code. Use two kinds: a retrieval question ("what does this guard protect against?") and a predict-the-output question ("what does this print for this input?"). Check: each turn holds exactly one question and no hint at the answer.
3. **Key by running.** Before asking a predict-the-output question, run the apprentice's code (or a call to it) with the input and record the real output as the key; never derive the key by reading. Run without editing any file. If it cannot be run, or the output is not deterministic, replace the question with a retrieval one. Check: every predict-the-output key came from a run.
4. **Feedback.** After each answer, say whether it matches the key, then explain why the answer is right or wrong in terms of the concept, and show the real output for a predict question. A wrong answer gets the explanation plus one follow-up question in the next turn, not a rewrite of their code. Check: every answer gets an explanation, right or wrong.
5. **Close.** Name the questions they missed as the topics to revisit and offer `/mentor-tutor teach <topic>` on one of them. Check: the close lists missed topics; the quiz writes no journal line.

The apprentice may stop at any question; say so and stop.
