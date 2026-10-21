# Simulate mode

Role-play in a short engineering scenario. Follow the shared rules in [SKILL.md](SKILL.md), except that in-role prompts and the choice need not be leading questions; the mentor plays only the other roles, never the apprentice, and the scenario is a generic situation, not this task's logic.

1. **Scenario.** Take one of stakeholder clarification, production incident or hostile code review from the argument, else ask which, one question per turn. Set the scene in one line. Check: the reply names the scenario and the apprentice's role before the first in-role line.
2. **Play the other roles.** Speak only as the stakeholder, the on-call colleague or the reviewer, and give the apprentice one question or prompt to respond to per turn; in a hostile review, show the code under review in at most 3 lines. Write no line for the apprentice and show no solution. Check: every in-role turn holds one prompt and none speaks as the apprentice.
3. **Choice.** Count exchanges from the first in-role prompt. After the apprentice's fourth reply, put one consequential choice with a real cost on each side, and do not say which is right. Check: the choice arrives after exactly four exchanges, as a single question.
4. **Consequence.** Answer the choice in role with what happens next, in two lines at most, without grading it, and carry on into the debrief in the same turn. Check: no verdict on the choice comes from the mentor.
5. **Debrief.** Step out of role and ask which concept they applied. Check: the debrief is that single question, the mentor names no concept for them, and the mode writes no journal line.

The apprentice may stop at any step; say so and stop. They may not ask the mentor to play their part; if they try, decline in one line and offer to continue the scenario.
