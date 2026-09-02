# PROGRESS.md — read first, every session

> **Tutor:** read this file and `REVIEW.md` before saying anything else, then
> open with the three-line status. The student assumes they remember nothing.

## Position

- **Phase:** 0 — Orientation
- **Module:** 0.1 — A server is a process (**worked through A–D**; module
  gate not yet formally administered — it folds into the Phase 0 gate)
- **Next gate:** Phase 0 — trace a request end to end, naming every layer

## Cadence

- Budget: 4–6 h/week, irregular blocks; zero weeks happen and are fine.
- Anchor session: **Wednesday or Friday evening**, not guaranteed (student's
  own framing, 2026-08-30). Treat as a target, not a commitment — if two
  weeks pass with neither, revisit whether the anchor idea is working at all.
- Week of 2026-08-25: 4–6 h available.

## Last session

- 2026-09-01 (~2 h, ran past midnight) — Module 0.1 worked end to end.
  Ran `python3 -m http.server`, dissected `curl -v`, found the process with
  `lsof`, killed it, served a request by hand with `nc`, filled in the
  where-state-lives table. Review: FK/index item passed, plan-reading item
  missed again. Two accidental findings from the student's own output —
  `.env` and `.git/` being served over HTTP, and cookies from other localhost
  apps arriving at a bare `nc` listener (cookies scope by host, not port).

## Next session — first thing to do

1. `phases/phase-0-orientation/exercises/02-trace-a-request.md` — Module 0.2,
   the life of one request. This one also verifies the Tweede Kamer OData
   base URL from the student's machine (`capstone/README.md` was written from
   documentation, never live-tested — if the URL moved, fix it there).
2. Expect the due `REVIEW.md` items quizzed first — the plan-reading one is
   at stage 1 for the second time and gets asked properly.

## Needs revisiting

- ~~**2026-08-30 — foreign keys and indexes.**~~ **Cleared 2026-09-01:**
  predicted `Seq Scan` on `tracks.album_id` unaided and named the cause —
  no index exists, `REFERENCES` creates a constraint. Still cycling in
  `REVIEW.md` at stage 2.
- **2026-08-30 — "fast" vs "efficient" / reading a plan.** *Missed again
  2026-09-01.* Given `rows=1200 loops=3, Rows Removed by Filter: 98800`,
  answered 100,000 rows examined. The per-loop figures must be multiplied by
  `loops`: (1200 + 98800) × 3 = 300,000. Same arithmetic as the 1.67M × 3 = 5M
  from the smoke test. Cleared by getting the multiplication right cold.
- **2026-09-01 — where state lives, rows 3 and 4.** Cart initially placed in a
  cookie (4KB cap; sent on every request). Page HTML now answered only as the
  rendered DOM — the fuller truth is that it exists in two places at once,
  source on the server, rendered copy in the browser. Cleared by reproducing
  the four-row table cold at the Phase 0 gate.
- **Not a gap, a signpost:** the student flagged `playlists` /
  `playlist_tracks` as unintuitive. That's a junction table for a
  many-to-many relationship — untaught material, due properly in Phase 1
  (1.2 joins, 1.6 schema design). Do not answer it early; use it as the
  motivating example when 1.2 arrives.

## Claim ledger

Résumé-grade claims, added **only** when a phase gate is passed, each backed
by an artifact in this repo. Empty is the honest starting state.

| Claim | Evidence | Earned |
|---|---|---|

## Session log

*(Tutor appends one row per session, including short ones. "Next first step"
is the cold-start hook for the following session.)*

| Date | Hours | What happened | Next first step |
|---|---|---|---|
| 2026-08-27 | — | Course scaffolded by tutor. Decisions: capstone = Tweede Kamer vote tracker (official OData API); Postgres via Docker; anchor = weekday evening (day TBD); 4–6 h available this week. | Run `00-smoke-test.md` |
| 2026-08-30 | 0.5 | Exercise 00 done. `make up` clean, gym seeded (5M `plays`). Predictions: row count right (5M), both timings wrong. `EXPLAIN ANALYZE` introduced; predicted `Index Scan`, got `Parallel Seq Scan`, 1.67M rows discarded per worker. Corrected: FKs don't create indexes in Postgres. Baseline receipt for Module 1.7: **84ms** for `count(*) FROM plays WHERE user_id = 4242`. Anchor weekday: Wed or Fri, unguaranteed. | Start `01-a-server-is-a-process.md` |
| 2026-09-01 | ~2 | Module 0.1 A–D. HTTP server started, `curl -v` dissected line by line, `lsof -i :8000`, process killed, one response typed by hand into `nc`, state table filled and corrected. Taught: HTTP/1.0 vs 1.1 connection reuse, the connection 4-tuple and ephemeral ports, what dies with a process (binding, sockets, heap — not disk), status codes are for machines, session state as client identifier + server record. Two live findings from his own machine: `.env`/`.git/` served over HTTP, and cookies crossing ports on localhost. Review: FK/index passed → stage 2; plan-reading `loops` arithmetic missed → stage 1 again. | Start `02-trace-a-request.md` |
