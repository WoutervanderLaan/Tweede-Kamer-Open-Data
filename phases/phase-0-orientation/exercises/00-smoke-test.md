# 00 — Smoke test: the environment works and you can prove it

Goal: containers running, seeded database answering queries, and your first
taste of why this course insists on millions of rows. ~30–45 minutes.

## 1. Prerequisites

- Docker Desktop or OrbStack installed and running on your Mac.
- If you already run Postgres locally on 5432: `cp .env.example .env` and
  change `POSTGRES_PORT` before starting.

## 2. Bring it up

```sh
make up
make logs     # watch the seed happen — this is a one-time, few-minute job
```

Leave the logs open until you see `=== gym seed complete ===`, then Ctrl-C.
`make status` should show postgres as `(healthy)`.

While it seeds, read `db/init/002_gym_schema.sql` top to bottom. Don't read
the seed script yet — it spoils some surprises you're meant to find with
queries.

## 3. First contact

```sh
make psql
```

Inside psql — these four are your survival kit:

```
\dt              -- list tables
\d plays         -- describe one
\timing on       -- print every query's duration from now on
\q               -- leave
```

## 4. Predict, then run

Before each query, **write your guess down** (a number and a duration — order
of magnitude is fine). Then run it. This predict-first habit is how the whole
course works, so start now.

1. How many rows are in `plays`? How long will counting them take?

   ```sql
   SELECT count(*) FROM plays;
   ```

2. How long to find one user's plays in those millions of rows?

   ```sql
   SELECT count(*) FROM plays WHERE user_id = 4242;
   ```

3. The five most-played tracks of the last 30 days — you may not fully read
   this query yet, that's fine, run it anyway:

   ```sql
   SELECT t.title, count(*) AS n_plays
   FROM plays p
   JOIN tracks t ON t.id = p.track_id
   WHERE p.played_at > now() - interval '30 days'
   GROUP BY t.title
   ORDER BY n_plays DESC
   LIMIT 5;
   ```

## 5. Write down (in `notes/00-smoke-test.md`)

- Your three predictions vs reality — where were you most wrong?
- The duration of query 2. **Keep this number.** In Module 1.7 you will make
  this exact query dramatically faster, and you'll want the receipt.
- One thing about the schema that surprised you or that you'd have designed
  differently. No wrong answers yet — this is a baseline of your instincts.

Done? Tell the tutor your three numbers, and move on to exercise 01.
