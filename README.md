# Backend Engineering Course — Tweede Kamer Open Data

A self-directed backend course for a frontend engineer, taught session by
session by Claude Code acting as tutor. One capstone — a voting tracker built
on the Dutch parliament's open-data API — carried from raw SQL through to a
deployed, monitored service.

The tutor does not write the student's code. Gates are pass/fail. Solutions
are deliberately absent from this repo.

## Start a session

Open Claude Code in this repo and type:

```
/course
```

It reads `PROGRESS.md` and `REVIEW.md`, tells you where you are in three
lines, and runs the session. `/course end` closes one out; `/course status`
just says where you stand.

## The environment

Requires Docker Desktop or OrbStack.

```sh
make up        # Postgres 17 + Redis 7; first boot seeds ~6.5M rows (takes minutes)
make status    # postgres "(healthy)" = seeded and ready
make psql      # into the practice db (gym)
make           # all commands
```

Two databases: **gym** — pre-seeded practice data, big enough that bad
queries visibly hurt — and **capstone**, empty until you design its schema.
Port clash? `cp .env.example .env` and edit.

## The files that matter

| File | What |
|---|---|
| `CURRICULUM.md` | Full plan: phases, modules, what you'll learn/build, gates |
| `PROGRESS.md` | Where you are; read first every session |
| `REVIEW.md` | Spaced-repetition queue of things that wobbled |
| `CLAUDE.md` | The tutor's standing orders (teaching rules live here) |
| `capstone/` | The project brief and, over time, everything you build |
| `phases/` | Exercises (tutor-written) and your work (student-written) |
| `db/init/` | Schema + seed for the gym database |

## First session

`PROGRESS.md` → *Next session*. In short: `make up`, then
`phases/phase-0-orientation/exercises/00-smoke-test.md`.
