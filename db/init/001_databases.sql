-- Runs automatically, once, on the very first container start (files in
-- db/init/ execute in filename order). To re-run everything from scratch:
-- `make reset`.

-- Your database. Empty on purpose: you design what goes in it (Module 1.6).
CREATE DATABASE capstone;

-- Query statistics extension, used from Module 1.7 onward.
\connect gym
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

\connect capstone
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
