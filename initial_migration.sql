CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS app_public;
CREATE SCHEMA IF NOT EXISTS app_private;

CREATE TABLE IF NOT EXISTS app_public.users (
    id uuid PRIMARY KEY,
    username text NOT NULL UNIQUE,
    created_at timestamptz NOT NULL DEFAULT now()
)