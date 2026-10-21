# Working on this repo

This repo ships five skills as Markdown and a Claude Code plugin manifest. It is not an application.

## Layout

- `skills/mentor-<name>/SKILL.md`: one directory per skill, flat; the frontmatter `name` matches the directory. Detail goes in sibling files one level deep.
- `.claude-plugin/`: `plugin.json` and `marketplace.json`; `skills` points at `./skills`.
- `CONTEXT.md`: the glossary. Use its terms in skills and docs.
- `docs/adr/`: durable decisions. `docs/planning/{ID}/`: active plans. `docs/archive/planning/{ID}/`: finished plans.

## Rules

- Skills never write production logic or function bodies for the developer; that invariant is the product. A change that weakens it needs an ADR.
- Skills are named `mentor-<verb>` so they never collide with host built-ins.
- Keep each `SKILL.md` under 100 lines.
- Skills never run git commits; committing is the developer's step.
- No AI attribution in commits, docs or code comments.
