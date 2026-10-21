# Apprentice

An AI-assisted mentorship framework that inverts the usual coding assistant. The AI never writes core production logic or function bodies. It sets up the tedious parts (test runners, fixtures, mocks, interface stubs) and coaches; the developer writes the code that turns the tests green.

## Philosophy

Tools that hand over complete implementations turn junior developers into reviewers of diffs they did not write. Apprentice keeps the hands-on work with the developer:

- **Primary invariant:** the AI does not write production business logic or function bodies.
- **Automated scaffolding:** test suites, fixtures, mocks, assertion matrices and typed stubs are generated for you.
- **Hands-on execution:** you write the code that makes the failing tests pass.
- **Socratic guidance:** help is metered through a ladder (Concept, Pseudocode, Decomposition), never a full solution.
- **Comprehension gates:** before a phase closes, you answer one conceptual question about complexity, edge cases or trade-offs.

## Lifecycle

```text
/mentor-plan -> /mentor-scaffold -> you code (/mentor-hint, /mentor-diagnose) -> /mentor-review
```

| Command | Stage | What it does |
|---------|-------|--------------|
| `/mentor-plan` | Planning | Interviews you one question at a time, decomposes the work into vertical slices, writes `docs/planning/{ID}/` and a proposed ADR |
| `/mentor-scaffold` | Scaffolding | Writes the failing test suite (Red) and a stubbed interface with pseudocode that throws an unimplemented error |
| `/mentor-hint` | Implementation | Tiered help: Level 1 concept, Level 2 pseudocode, Level 3 micro-step decomposition |
| `/mentor-diagnose` | Implementation | Walks you through a five-step debugging loop without patching the bug for you |
| `/mentor-review` | Verification | Runs tests, lint and type-check, checks tests were not weakened, audits module design, asks one comprehension question |

## Install

**Claude Code plugin:**

```text
/plugin marketplace add rshingleton/apprentice
/plugin install apprentice@apprentice
```

Plugin skills are namespaced, for example `/apprentice:mentor-plan`.

**Symlink install** (skills link inside `skills/`, so they keep working):

```sh
git clone git@github.com:rshingleton/apprentice.git ~/.local/share/apprentice
ln -s ~/.local/share/apprentice/skills/mentor-* ~/.claude/skills/
```

Use the plugin or the symlinks, not both.

## Usage

1. Run `/mentor-plan` with the task or epic and answer its questions.
2. Run `/mentor-scaffold` for the first phase. Open the stub, read the pseudocode and make the tests pass.
3. Stuck? Run `/mentor-hint`, or `/mentor-diagnose` for a failing test.
4. When the tests pass, run `/mentor-review`. Answer its question to close the phase.
5. Repeat `/mentor-scaffold` for the next slice. Commit yourself; the skills never commit.

## Repository layout

```text
CONTEXT.md        domain glossary (Ubiquitous Language)
docs/adr/         architectural decision records (durable)
docs/planning/    active task plans, one directory per ID
docs/archive/     completed plans, moved to docs/archive/planning/{ID}/
skills/           the five mentor-* skills
.claude-plugin/   plugin and marketplace manifests
```

Context follows the accordion model: detailed planning lives in `docs/planning/{ID}/`, execution stays focused in the active source file, and a finished plan is archived while lasting decisions move into `docs/adr/`.
