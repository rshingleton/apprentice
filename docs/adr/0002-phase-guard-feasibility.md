# 0002: A plugin hook can enforce the phase guard

Status: accepted 2026-10-21

## Context
Roadmap goal G1 wants the invariant enforced by the tool: while a phase is active, the AI cannot edit production source, only tests, stubs, exercises and docs. Spike R1 asked whether a Claude Code hook can deny an edit by path using a phase marker.

## Decision
Yes, with limits. A PreToolUse command hook can do it, and the plugin can ship it.

Evidence:
- A PreToolUse hook receives JSON on stdin with `tool_name`, `tool_input`, `cwd` and `permission_mode`. `Edit` and `Write` carry an absolute `tool_input.file_path` (https://code.claude.com/docs/en/hooks).
- Printing `{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"..."}}` denies the call, and Claude sees the reason. Exit code 2 with stderr also denies.
- A throwaway script given sample JSON for `src/a.js`, `src/a.test.js`, `tests/a.js`, `exercises/e.js` and `docs/n.md` denied only `src/a.js`, and only while a marker file (a `phase-active` file anywhere under `docs/planning/`, not the per-ID `docs/planning/{ID}/` layout D1 will settle) existed. With no marker every path was allowed.
- A live `claude -p` session with the hook in a scratch settings file and `--permission-mode bypassPermissions` had the `Edit` to `src/a.js` denied, with the reason shown to Claude. The `Edit` to `src/a.test.js` succeeded. So the deny holds in bypass mode on this build; the docs do not say so.
- A plugin can register hooks in `hooks/hooks.json` (or the `hooks` field of `plugin.json`), using `${CLAUDE_PLUGIN_ROOT}` for the script path and `CLAUDE_PROJECT_DIR` for the project root (https://code.claude.com/docs/en/plugins-reference).

## Limits
- An `Edit|Write` matcher does not see writes made through `Bash` (`sed -i`, redirects). Closing that needs a second `Bash` matcher that inspects `tool_input.command`, which can only be a heuristic.
- The docs say hooks are not a hard boundary. `disableAllHooks` turns every hook off, and a plugin's hooks cannot be disabled one by one. The guard raises the cost of outsourcing; it does not stop a user who disables it.
- The docs give no `tool_input` field names for `MultiEdit` or `NotebookEdit`, and they were not tested. R2 must dump their input before relying on a path field.
- Exit 0 with no output is "no decision", not approval, so the guard stays silent when it allows.

## Consequences
- R2 may start once D1 is answered: what counts as a production path, and where the marker lives. The spike's rule (`src/` minus test files) and marker (a file under `docs/planning/{ID}/`) were only for the experiment.
- D1 also has to answer: how the hook finds the active phase when several plans exist, and who creates and removes the marker (a skill step or the apprentice).
- R2 allows `exercises/`, consistent with ADR 0001.
- R2 decides whether to add the `Bash` heuristic or to name the gap in README Limits.

## Execution notes
R2 shipped the hook as `hooks/phase-guard.sh`, registered in `hooks/hooks.json`, with D1's marker layout. Checked in a live session afterwards: with the shipped plugin and a marker listing `src/a.js`, the `Edit` to it was denied with the guard's reason and the `Edit` to the test file succeeded; `NotebookEdit` carries `notebook_path`. Not checked: `MultiEdit`, which this build does not have (the hook reads `file_path` for it). Audit notes: a marker line naming a directory needs a glob (`src/*`); a `|` in a marker line acts as glob alternation; this repo's own `.gitignore` does not list `docs/planning/**/ACTIVE`. The `Bash` gap is named in README Limits, with no heuristic.
