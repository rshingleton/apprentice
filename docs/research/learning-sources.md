# Learning sources for the Apprentice framework

Findings from outside material on training junior developers with AI. Page fetches were summarised by a small model except the Mollick paper, which was read in full (text extracted from the PDF).

## Sources

- Mollick, E. and Mollick, L. (2023). [Assigning AI: Seven Approaches for Students, with Prompts](https://papers.ssrn.com/abstract=4475995). Wharton. 46 pages; read in full.
- [microsoft/prompts-for-edu](https://github.com/microsoft/prompts-for-edu), `Students/Prompts/`: Tutor, Quiz Me, Devil's Advocate, Peer Teaching, Simulator, Team Member, Team Pre-mortem Coach, Team Reflection Coach, Writing Mentor. Most come from the paper above. Titles and prompt text only; license not checked.
- GitHub Blog, [Junior developers aren't obsolete](https://github.blog/ai-and-ml/generative-ai/junior-developers-arent-obsolete-heres-how-to-thrive-in-the-age-of-ai/).
- Curtis Poe, [How we'll train junior devs in the age of AI](https://www.linkedin.com/pulse/how-well-train-junior-devs-age-ai-curtis-poe-3vwsf/).
- SoftwareSeni, [Junior developers in the age of AI](https://www.softwareseni.com/junior-developers-in-the-age-of-ai-who-trains-the-next-generation-of-engineers/). Its comprehension figures (50% versus 67%) are attributed to an Anthropic study; the study itself was not traced. Do not quote them until it is.

## What the Mollick paper adds

The paper maps seven AI roles to a learning-science basis and a named risk. Cited bases are read from the paper, not from the original studies.

| Role | Basis (as cited) | Named risk |
|------|------------------|------------|
| Mentor | Frequent, goal-oriented feedback; feed-up, feedback, feed-forward | Feedback not examined critically |
| Tutor | Active construction of answers (Chi et al.); leading questions; explain in own words | Confabulation, uneven knowledge |
| Coach | Reflection after action; prospective hindsight (premortem); self-distancing | Mirrors tone; loops; bad advice |
| Teammate | Groupthink and process loss (Hackman, Edmondson); devil's advocate | Students defer to the AI as they would not to a peer |
| Student | Teaching others; familiarity is not fluency; elaborative interrogation | Student may lack the knowledge to catch the AI's errors |
| Simulator | Deliberate practice; transfer needs explicit abstraction and self-monitoring | Inappropriate fidelity; extraneous load from unfamiliar scenarios |
| Tool | Extends what students can do | Outsourcing thinking rather than work |

Design points worth keeping:

- **Preconditions.** Mentor feedback, AI-as-student and the simulator are for learners who already have foundational knowledge; coaching and tutoring can start earlier.
- **Build-your-own recipe.** Role, goal, step-by-step instructions, examples, personalisation, then "add your pedagogy" (the mistakes learners typically make) and constraints.
- **Test the prompt adversarially.** Try to break the tutor pedagogically (ask for the answer) and conceptually (make the typical mistakes). Try a great, a middling and a poor submission on the mentor.
- **Known failure modes.** The model forgets one-question-at-a-time, loops on one topic, and varies run to run. The appendix's compatibility chart (2023) shows prompts working on some models and not others.
- **Learner autonomy.** Students are told they are in charge: skip a step, end the chat, ignore the advice. They report the whole interaction with a reflection paragraph, and share nothing they are not comfortable sharing.
- **Maturity.** The authors call these approaches "in their infancy and largely untested".

## Consequences for Apprentice

- Code gives ground truth the paper lacks: an AI-student exercise with planted, known flaws can be checked by a failing test the apprentice writes, and a quiz answer key can be checked by running the code.
- The AI-teammate risk is real here: an apprentice may defer to the mentor's suggestions. Ask for an explicit accept or reject, with a reason.
- Developers have a privacy risk the paper only touches: proprietary code and secrets pasted into a model.
- The Devil's Advocate prompt lets the AI answer its own questions when the student struggles. Apprentice must not.
