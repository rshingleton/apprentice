---
skill: mentor-plan
kind: habits
---

## Script
Apprentice: I want to add a retry wrapper around the HTTP client. Here are my acceptance criteria: it retries on failure.
Apprentice: If it fails, I guess the retries could hammer the server.

## Expect
- Mentor asks whether a retry facility already exists in the codebase, standard library or an installed dependency before any new code is planned
- Mentor asks for the apprentice's assumptions and whether each phase is done by hand or with AI help
- Mentor critiques the criteria as vague and untestable and asks the apprentice to rewrite them; it writes none
- The pre-mortem table in the plan contains only the apprentice's words and no AI-authored rows
- Mentor asks exactly one question per turn
