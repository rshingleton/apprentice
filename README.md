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

**Installer** (symlinks the skills into `~/.claude/skills` and `~/.agents/skills`):

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/rshingleton/apprentice/main/scripts/install.sh)
```

It clones the repo into `~/.local/share/apprentice` (or pulls it when the clone is there), then links from the clone; re-run it to update. Set `APPRENTICE_REPO` to clone from another URL, such as the SSH one, and `APPRENTICE_HOME` to use another clone directory.

From a clone:

```sh
git clone git@github.com:rshingleton/apprentice.git ~/.local/share/apprentice
~/.local/share/apprentice/scripts/install.sh            # link the skills
~/.local/share/apprentice/scripts/install.sh --dry-run  # show what it would do
~/.local/share/apprentice/scripts/install.sh --force    # replace entries that are not ours
~/.local/share/apprentice/scripts/install.sh --uninstall
~/.local/share/apprentice/scripts/install.sh -h           # usage
```

It leaves any existing entry that is not its own link alone unless `--force` is given. A link made from a different clone path counts as not its own, so after moving the clone run `--uninstall` from the old one, or install with `--force`. `scripts/test-install.sh` checks the installer against a temporary `HOME`.

Use the plugin or the installer, not both.

## Evals

`evals/run.sh` checks every skill offline: its name and description, routing cases (each trigger phrase is in its own skill's description and in no other), scripted scenarios, the one-question-per-turn rule on transcript fixtures, and each skill's anatomy (a "Use when" description, under 100 lines, and Pedagogy, Risks and Apprentice in charge sections). It exits non-zero on any failure. `evals/test-evals.sh` proves it fails on a broken description, a two-question transcript and a missing scenario. Scenarios are scripted expectations for a run of the skill; they are not executed against a model.

## Usage

1. Run `/mentor-plan` with the task or epic and answer its questions.
2. Run `/mentor-scaffold` for the first phase. Open the stub, read the pseudocode and make the tests pass.
3. Stuck? Run `/mentor-hint`, or `/mentor-diagnose` for a failing test.
4. When the tests pass, run `/mentor-review`. Answer its question to close the phase.
5. Repeat `/mentor-scaffold` for the next slice. Commit yourself; the skills never commit.

## Limits

- **Privacy:** do not paste secrets, credentials or proprietary code into a session where your organisation's policy forbids sharing them with a model.
- **Prompt-enforced:** the rule that the AI writes no production logic is carried by the skills' instructions. Nothing in the tool blocks an edit yet.
- **Not run against a model:** the evals check structure and scripted expectations only, so a skill can pass them and still behave differently on a given model.
- **Learner journal:** `mentor-hint` and `mentor-review` keep a personal journal of your level, hints and answers at `~/.apprentice/journal.md` (or `$APPRENTICE_JOURNAL`). It sits outside every repository, is never committed, and deleting the file resets it.
- **Model output can be wrong:** hints and reviews may be mistaken or confidently misleading. Check them against the code and the documentation.
- **You are in charge:** you may skip a process step or end a session. Test integrity and the comprehension question stay in place.

## Credits

The skills borrow ideas, rewritten in this repo's words, from:

- Mollick, E. and Mollick, L. (2023). [Assigning AI: Seven Approaches for Students, with Prompts](https://papers.ssrn.com/abstract=4475995): mentor feedback, leading questions, premortems, adversarial testing of prompts and learner autonomy.
- [microsoft/prompts-for-edu](https://github.com/microsoft/prompts-for-edu): the tutor, quiz and devil's-advocate prompt shapes the paper builds on.

Notes on these and other sources are in [docs/research/learning-sources.md](docs/research/learning-sources.md).

## Repository layout

```text
CONTEXT.md        domain glossary (Ubiquitous Language)
docs/adr/         architectural decision records (durable)
docs/planning/    active task plans, one directory per ID
docs/archive/     completed plans, moved to docs/archive/planning/{ID}/
skills/           the five mentor-* skills
scripts/          install.sh and its test
evals/            offline skill checks: routing cases, scenarios, transcript fixtures
.claude-plugin/   plugin and marketplace manifests
```

Context follows the accordion model: detailed planning lives in `docs/planning/{ID}/`, execution stays focused in the active source file, and a finished plan is archived while lasting decisions move into `docs/adr/`.
