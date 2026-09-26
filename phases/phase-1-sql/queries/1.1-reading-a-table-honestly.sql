-- predict: largest table is 'tracks' (~2000 rows. This is the primary resource of the app and smallest unit), smallest is 'playlists' (~100, optional resource, and can hold many tracks)
-- actual: largest table is 'plays' (~5M rows, events dwarf entities), smallest is 'artists'.

COMMENT ON COLUMN subscriptions.ended_on IS 'NULL = still running'; 
-- actual output:
-- ended_on   | date   |           |          |                              | plain    |             |              | NULL = still running
