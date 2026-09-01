# Notes

## Your three predictions vs reality — where were you most wrong?

I made a mistake in answer 2. I wanted to answer a query time that was very fast, but wrote ~1s, which is relatively slow.

I was wrong in almost all questions, and additionally in the question (EXPLAIN ANALYZE) "which will the query plan say — Index Scan or Seq Scan on plays?"

My answers:

1. ~5M rows, ~0.2s. Pure guess
2. ~1s. Due to user id as foreign key, indexing is optimized and fast.
3. ~2s. Multiple filters applied, therefore slow.

---

The EXPLAIN ANALYZE of query #2:

```gym=# EXPLAIN ANALYZE SELECT count(*) FROM plays WHERE user_id = 4242;

QUERY PLAN
------
 Finalize Aggregate  (cost=71032.96..71032.97 rows=1 width=8) (actual time=82.872..84.049 rows=1 loops=1)
   ->  Gather  (cost=71032.74..71032.95 rows=2 width=8) (actual time=82.787..84.042 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=70032.74..70032.75 rows=1 width=8) (actual time=77.015..77.015 rows=1 loops=3)
               ->  Parallel Seq Scan on plays  (cost=0.00..70032.67 rows=31 width=0) (actual time=8.532..76.986 rows=38 loops=3)
                     Filter: (user_id = 4242)
                     Rows Removed by Filter: 1666629
 Planning Time: 0.238 ms
 Execution Time: 84.137 ms

```

## The duration of query 2

Execution Time: 84.137 ms

## One thing about the schema that surprised you or that you'd have designed differently

I am not sure how else to design it, but I was surprised with the `plays` table. I wonder if to keep a record of each play as such is convenient or makes sense. I guess it does, because where else to keep records of plays.

Also, I noticed a clear distinction between tables that involve that which is offered (artists, albums, tracks) vs tables that hold data related to usage (users, subs, plays). Perhaps this can be refined or build on somehow.

Another thing I find less intuitive is the playlists / playlist_tracks tables.
