-- runs ONCE, the first time the data volume is created
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_raster;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE SCHEMA IF NOT EXISTS raw;        -- bronze: data exactly as received
CREATE SCHEMA IF NOT EXISTS staging;    -- silver: cleaned (dbt)
CREATE SCHEMA IF NOT EXISTS analytics;  -- gold: final tables the API reads (dbt)
