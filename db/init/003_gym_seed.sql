-- Seeds the gym database. Runs once, automatically, on first container start.
-- Takes a few minutes: it generates ~6.5M rows, because a 50-row table
-- teaches you nothing about indexes.
--
-- Deliberate properties of this data (you'll meet all of them in Phase 1):
--   * Only PK/UNIQUE indexes exist. Nothing else is indexed. Postgres does
--     not index foreign key columns for you.
--   * Skew: a few heavy users produce most plays; a few hit tracks dominate.
--   * Warts: NULLs that mean different things, duplicate names, zero-length
--     tracks, a little impossible data. Real databases have all of these.
--
-- Pattern note: where one random roll feeds several CASE comparisons, the
-- roll is computed in the row-generating subquery and the subquery is fenced
-- with OFFSET 0, so the planner can neither inline the expression (one roll
-- per reference) nor evaluate the subquery just once for all rows.
--
-- Scale knobs (used below via :name):
\set n_users     100000
\set n_artists   10000
\set n_albums    40000
\set n_tracks    250000
\set n_playlists 30000
\set n_plays     5000000

SELECT setseed(0.2026);

\echo '=== seeding users (100k) ==='
INSERT INTO users (email, display_name, country_code, is_premium, created_at)
SELECT
    CASE WHEN random() < 0.10
         THEN 'User' || g.i || '@example.com'   -- mixed case on purpose
         ELSE 'user' || g.i || '@example.com'
    END,
    (ARRAY['Daan','Emma','Luuk','Julia','Sem','Mila','Finn','Tess','Bram','Sara',
           'Noah','Evi','Lars','Noor','Thijs','Lotte','Jesse','Fleur','Ruben','Anna'])[1 + ((g.i - 1) % 20)]
      || ' ' ||
    (ARRAY['de Vries','Jansen','van Dijk','Bakker','Visser','Smit','Meijer','Mulder',
           'de Boer','Kok','Hendriks','van Leeuwen','Dekker','Brouwer','de Wit','Peters'])[1 + (((g.i - 1) / 20) % 16)],
    CASE
        WHEN g.r < 0.40 THEN 'NL'
        WHEN g.r < 0.55 THEN 'BE'
        WHEN g.r < 0.68 THEN 'DE'
        WHEN g.r < 0.78 THEN 'GB'
        WHEN g.r < 0.86 THEN 'US'
        ELSE (ARRAY['FR','ES','PL','SE','IT','PT','DK'])[1 + floor(random() * 7)::int]
    END,
    random() < 0.22,
    timestamptz '2019-01-01' + random() * (timestamptz '2026-08-01' - timestamptz '2019-01-01')
FROM (SELECT i, random() AS r
      FROM generate_series(1, :n_users) AS i
      OFFSET 0) AS g;

\echo '=== seeding artists (10k) ==='
INSERT INTO artists (name, country_code, formed_year)
SELECT
    (ARRAY['The','De','Los','Die','Le'])[1 + ((g.i - 1) % 5)]
      || ' ' ||
    (ARRAY['Velvet','Neon','Broken','Electric','Silent','Golden','Canal','Northern','Paper','Wild'])[1 + (((g.i - 1) / 5) % 10)]
      || ' ' ||
    (ARRAY['Foxes','Tulips','Machines','Harbours','Echoes','Bicycles','Rivers','Sparrows','Windmills','Signals'])[1 + (((g.i - 1) / 50) % 10)]
      -- i 1..500 are unique combos; 501..520 repeat the names of i 1..20
      -- (two different artists CAN share a name); the rest get a suffix.
      || CASE WHEN g.i > 520 THEN ' ' || g.i ELSE '' END,
    CASE WHEN g.r < 0.15 THEN NULL   -- origin unknown
         WHEN g.r < 0.45 THEN 'NL'
         WHEN g.r < 0.60 THEN 'US'
         WHEN g.r < 0.72 THEN 'GB'
         WHEN g.r < 0.82 THEN 'DE'
         ELSE (ARRAY['BE','FR','SE','CA','AU','IS'])[1 + floor(random() * 6)::int]
    END,
    CASE WHEN random() < 0.20 THEN NULL
         ELSE 1960 + floor(random() * 66)::int
    END
FROM (SELECT i, random() AS r
      FROM generate_series(1, :n_artists) AS i
      OFFSET 0) AS g;

\echo '=== seeding albums (40k) ==='
INSERT INTO albums (artist_id, title, released_on)
SELECT
    -- power() skew: some artists have many albums, most have few or none
    1 + floor(power(random(), 2) * :n_artists)::bigint,
    CASE WHEN random() < 0.03 THEN 'Greatest Hits'
         ELSE (ARRAY['Midnight','Static','Polder','Golden','Echo','Rain','Analog','Glass',
                     'Hollow','First','Distant','Winter'])[1 + floor(random() * 12)::int]
              || ' ' ||
              (ARRAY['Signals','Sessions','Light','Tapes','City','Water','Lines','Days',
                     'Frequencies','Rooms','Letters','Fires'])[1 + floor(random() * 12)::int]
    END,
    CASE WHEN random() < 0.10 THEN NULL   -- release date never entered
         ELSE date '1970-01-01' + floor(random() * 20600)::int
    END
FROM generate_series(1, :n_albums) AS i;

\echo '=== seeding tracks (250k) ==='
INSERT INTO tracks (album_id, title, duration_ms, explicit)
SELECT
    1 + floor(power(random(), 1.5) * :n_albums)::bigint,
    (ARRAY['Undertow','Slow','North','Vapour','Marble','Second','Static','Harbour',
           'Glasswork','Copper'])[1 + floor(random() * 10)::int]
      || ' ' ||
    (ARRAY['Light','Motion','Skies','Song','Return','Sleep','Circuit','Weather',
           'Season','Line','Shift','Bloom'])[1 + floor(random() * 12)::int]
      || CASE WHEN g.r < 0.05 THEN ' (Live)'
              WHEN g.r < 0.10 THEN ' (Remastered)'
              WHEN g.r < 0.13 THEN ' (Acoustic)'
              ELSE ''
         END,
    CASE WHEN random() < 0.001 THEN 0    -- yes, really. Find these in 1.3.
         ELSE 45000 + floor(random() * 375000)::int
    END,
    random() < 0.08
FROM (SELECT i, random() AS r
      FROM generate_series(1, :n_tracks) AS i
      OFFSET 0) AS g;

\echo '=== seeding playlists (30k) ==='
INSERT INTO playlists (owner_id, name, is_public, created_at)
SELECT
    1 + floor(power(random(), 2) * :n_users)::bigint,
    (ARRAY['Focus','Gym','Roadtrip','Sunday Morning','Deep Work','Party','Rainy Day',
           'Commute','Dinner','Throwbacks','New Finds','Sleep'])[1 + floor(random() * 12)::int]
      || CASE WHEN random() < 0.3 THEN ' ' || (2019 + floor(random() * 8)::int) ELSE '' END,
    random() < 0.30,
    timestamptz '2020-01-01' + random() * (timestamptz '2026-07-01' - timestamptz '2020-01-01')
FROM generate_series(1, :n_playlists) AS i;

\echo '=== seeding playlist_tracks (~1.3M) ==='
INSERT INTO playlist_tracks (playlist_id, track_id, position, added_at)
SELECT
    p.id,
    1 + floor(power(random(), 2.5) * :n_tracks)::bigint,
    gs.pos,
    p.created_at + random() * (timestamptz '2026-08-20' - p.created_at)
FROM playlists AS p
-- length derived from p.id: an uncorrelated random() here would be rolled
-- once for the whole query, giving every playlist the same length
CROSS JOIN LATERAL generate_series(1, 10 + ((p.id * 37) % 70)::int) AS gs(pos)
ON CONFLICT DO NOTHING;   -- the same track can be picked twice for a playlist

\echo '=== seeding subscriptions (~75k) ==='
INSERT INTO subscriptions (user_id, plan, started_on, ended_on)
SELECT
    c.id,
    CASE WHEN c.r < 0.15 THEN 'trial'
         WHEN c.r < 0.70 THEN 'monthly'
         ELSE 'annual'
    END,
    c.started,
    CASE WHEN c.r2 < 0.45
         THEN least(c.started + (30 + floor(random() * 700))::int, date '2026-08-20')
         ELSE NULL   -- still running
    END
FROM (SELECT u.id,
             random() AS r,
             random() AS r2,
             least(u.created_at::date + floor(random() * 180)::int, date '2026-08-15') AS started
      FROM users AS u
      WHERE u.id % 10 < 6   -- ~60% of users ever subscribed
      OFFSET 0) AS c;

-- A second wave: some users resubscribed later. A few of these rows start
-- before the user's account existed. That is impossible. It is also the kind
-- of thing you will find in every production database you ever touch.
INSERT INTO subscriptions (user_id, plan, started_on, ended_on)
SELECT
    u.id,
    'monthly',
    date '2024-01-01' + floor(random() * 900)::int,
    NULL
FROM users AS u
WHERE u.id % 23 = 0;

\echo '=== seeding plays (5M) — the slow part, hang in there ==='
INSERT INTO plays (user_id, track_id, played_at, ms_played, device)
SELECT
    1 + floor(power(random(), 2) * :n_users)::bigint,    -- heavy-user skew
    1 + floor(power(random(), 3) * :n_tracks)::bigint,   -- hit-track skew
    timestamptz '2026-08-25' - power(random(), 2) * interval '2000 days',  -- mostly recent
    CASE WHEN g.r < 0.02 THEN 0   -- instant skip
         ELSE 1000 + floor(random() * 299000)::int
    END,
    CASE WHEN g.r2 < 0.40 THEN 'ios'
         WHEN g.r2 < 0.75 THEN 'android'
         WHEN g.r2 < 0.90 THEN 'web'
         ELSE 'desktop'
    END
FROM (SELECT i, random() AS r, random() AS r2
      FROM generate_series(1, :n_plays) AS i
      OFFSET 0) AS g;

\echo '=== updating planner statistics ==='
ANALYZE;

\echo '=== gym seed complete ==='
