-- The "gym": a fictional music-streaming service. All Phase 1 drills run
-- against this database.
--
-- You did not design this schema, and that is deliberate: reading a schema
-- you didn't write is half the job. Explore it with \dt and \d <table>.
-- The data has warts on purpose. Treat surprises as findings, not bugs.

CREATE TABLE users (
    id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email        text        NOT NULL UNIQUE,
    display_name text        NOT NULL,
    country_code char(2)     NOT NULL,
    is_premium   boolean     NOT NULL DEFAULT false,
    created_at   timestamptz NOT NULL
);

CREATE TABLE artists (
    id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         text NOT NULL,
    country_code char(2),
    formed_year  integer
);

CREATE TABLE albums (
    id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    artist_id   bigint NOT NULL REFERENCES artists (id),
    title       text   NOT NULL,
    released_on date
);

CREATE TABLE tracks (
    id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    album_id    bigint  NOT NULL REFERENCES albums (id),
    title       text    NOT NULL,
    duration_ms integer NOT NULL,
    explicit    boolean NOT NULL DEFAULT false
);

CREATE TABLE playlists (
    id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner_id   bigint      NOT NULL REFERENCES users (id),
    name       text        NOT NULL,
    is_public  boolean     NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL
);

CREATE TABLE playlist_tracks (
    playlist_id bigint      NOT NULL REFERENCES playlists (id),
    track_id    bigint      NOT NULL REFERENCES tracks (id),
    position    integer     NOT NULL,
    added_at    timestamptz NOT NULL,
    PRIMARY KEY (playlist_id, track_id)
);

CREATE TABLE subscriptions (
    id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id    bigint NOT NULL REFERENCES users (id),
    plan       text   NOT NULL CHECK (plan IN ('trial', 'monthly', 'annual')),
    started_on date   NOT NULL,
    ended_on   date   -- NULL = still running
);

-- The big one: every listen event since launch.
CREATE TABLE plays (
    id        bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id   bigint      NOT NULL REFERENCES users (id),
    track_id  bigint      NOT NULL REFERENCES tracks (id),
    played_at timestamptz NOT NULL,
    ms_played integer     NOT NULL,
    device    text        NOT NULL
);
