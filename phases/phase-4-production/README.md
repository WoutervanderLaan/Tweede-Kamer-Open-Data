# Phase 4 — Running it in production

Locked until the Phase 3 gate is passed.

Modules (details in `CURRICULUM.md`):
- **4.1** Config via environment, structured logging, Sentry.
- **4.2** Docker, gunicorn, Fly.io, a real domain, migrations against real
  data, backups you have actually restored.
- **4.3** Celery + Redis — the importer becomes a nightly job that survives
  its worker being killed.
- **4.4** Caching and invalidation, rate limiting.

**Gate out of this phase:** the capstone is live on a real domain, and for
every process in the system you can answer "what happens when this dies?"

Deploy config and `OPERATIONS.md` live in `capstone/`.

## Layout

- `exercises/` — tutor-written (kill drills, migration rehearsals, cache
  invalidation puzzles).
- `notes/` — yours, including the post-mortem write-ups of the drills.
