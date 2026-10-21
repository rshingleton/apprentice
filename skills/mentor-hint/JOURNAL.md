# Learner journal

A personal, append-only record of how the apprentice is doing. `mentor-hint` and `mentor-review` write it; nothing else does yet.

## Where
- `$APPRENTICE_JOURNAL` when set, else `~/.apprentice/journal.md`. Create the directory and file on the first write.
- Never inside a repository, so it is never committed. Deleting the file resets it.
- Best effort: if the file is missing, unwritable or the apprentice declines, say so once and carry on. Journaling never blocks a hint or a sign-off.

## What goes in
The apprentice's words in one short plain phrase. No code, no secrets, no proprietary names.

## Format
A `## Profile` block, written once and global:

    ## Profile
    - skill: <their own words for how experienced they are>
    - prior knowledge: <one phrase>

An empty Profile means the file or this block is missing: ask level and prior knowledge once, in one question, then write it.

Then one line per event under `## Log`, dated `YYYY-MM-DD`. A phase id is the task id plus `phase-N`, for example `csv-export/phase-2`.

    - <date> | <project> | <phase id> | hint | level <1-3> | <topic>
    - <date> | <project> | <phase id> | phase-closed | hints <n>
    - <date> | <project> | <phase id> | explained | <their answer, one line>
    - <date> | <project> | <phase id> | skipped | <process step>

`hints 0` on a `phase-closed` line means the apprentice debugged that phase unaided. Count a phase's hints from its `hint` lines.
