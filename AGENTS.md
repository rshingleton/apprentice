# Working on this repo

This repo ships six skills as Markdown and a Claude Code plugin manifest. It is not an application.

## Layout

- `skills/mentor-<name>/SKILL.md`: one directory per skill, flat; the frontmatter `name` matches the directory. Detail goes in sibling files one level deep.
- `.claude-plugin/`: `plugin.json` and `marketplace.json`; `skills` points at `./skills`.
- `hooks/`: the phase-guard PreToolUse hook and its `hooks.json`; `scripts/test-phase-guard.sh` tests it. Run it after changing the hook.
- `evals/`: offline checks for the skills; run `evals/run.sh` before changing a skill description, and `evals/test-evals.sh` after changing the evals.
- `CONTEXT.md`: the glossary. Use its terms in skills and docs.
- `docs/adr/`: durable decisions. `docs/planning/{ID}/`: active plans. `docs/archive/planning/{ID}/`: finished plans.

## Skill anatomy

Every `SKILL.md` has, in this order:

- Frontmatter: `name` (the directory) and a third-person `description`: what it does, then "Use when" its triggers.
- `## Role` and `## Universal Directives`.
- `## Workflow`, or the skill's named ladder or loop: numbered steps, each ending on a check the apprentice or the mentor can observe.
- `## Pedagogy`: the habit it trains and why.
- `## Risks`: how the apprentice could outsource their thinking, or the mentor leak a solution, and the counter.
- `## Apprentice in charge`: which steps they may skip or end, and which they may not.

Process steps are skippable, and the skill that writes the learner journal journals the skip (today `mentor-review`; the other skills join as they gain journal writes). Test integrity and the comprehension gate are never skippable.

A skill that outgrows 100 lines moves detail into a sibling file, linked one level deep. A new mode is a sibling file inside an existing skill, not a new skill, unless it has its own trigger phrase in `evals/routing.tsv`. `evals/run.sh` checks the description, the length and the three sections.

## Rules

- Skills never write production logic or function bodies for the developer; that invariant is the product. A change that weakens it needs an ADR.
- Skills are named `mentor-<verb>` so they never collide with host built-ins.
- Keep each `SKILL.md` under 100 lines.
- Skills never run git commits; committing is the developer's step.
- No AI attribution in commits, docs or code comments.
