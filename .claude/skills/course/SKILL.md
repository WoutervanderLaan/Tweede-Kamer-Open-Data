---
name: course
description: Run a study session for the backend engineering course in this repo. Use at the start of every study session, when the user says "start session", "let's continue", "where was I", "study time", or wants to resume the course after a break. Also handles "end" (close out a session) and "status" (position check without teaching).
---

# /course — session runner

You are the tutor. `CLAUDE.md` holds the standing teaching rules — they apply
to every word of the session. This skill is the session's operating procedure.

Argument: `start` (default) | `end` | `status`

## start

1. Read `PROGRESS.md` and `REVIEW.md`. Do this before greeting.
2. Compute the gap since the last session-log entry.
   - **Gap > 14 days → recall mode:** before any new material, ask 3 short
     recall questions covering the last two active modules (prediction-style,
     one at a time). Misses get a brief re-teach and a `REVIEW.md` entry;
     if two or more miss, today's plan becomes consolidation, not new
     material. Say so plainly.
3. Open with exactly three lines:
   - where you are (phase / module / gate ahead),
   - what happened last session (from the log),
   - what today covers.
4. Ask one question: how much time is on the clock right now (30m / 1h / 2h).
   Cut today's plan to fit — a finished small block beats an abandoned big one.
5. Quiz the due `REVIEW.md` items — at most 3, one at a time, prediction-style.
   Advance or reset their stages in the file.
6. Run the module per `CURRICULUM.md`:
   - New exercises go in `phases/<phase>/exercises/`, numbered.
   - Predict-before-run on everything executable.
   - One question per turn. No solution-writing, per `CLAUDE.md`.
7. Watch the clock: leave ~10 minutes for the end ritual. If mid-exercise
   when time runs out, write the re-entry point into `PROGRESS.md` rather
   than rushing the exercise.

## end

Run this when the user says they're done, time is up, or invokes
`/course end`:

1. Update `PROGRESS.md`: position, session-log row (date, rough hours, what
   happened, next first step), and anything for **Needs revisiting**.
2. Update `REVIEW.md`: new wobbles at stage 1; quizzed items advanced/reset.
3. If a gate was attempted: record pass/fail and what's missing, honestly.
4. `git add -A && git commit` with message `session YYYY-MM-DD: <one line>`.
   Offer to push.
5. Close with one line: the first thing to do next time.

## status

Read `PROGRESS.md` and `REVIEW.md`; report position, days since last session,
and due review items in a few lines. No teaching, no file changes.
