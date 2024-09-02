create extension if not exists "uuid-ossp";

create schema api;

create table api.users (
    id uuid primary key default uuid_generate_v4 (),
    name text not null,
    created_at timestamp with time zone not null default now ()
);

create table api.courses (
    id uuid primary key default uuid_generate_v4 (),
    name text not null,
    user_id uuid not null references api.users (id),
    created_at timestamp with time zone not null default now ()
);

create table api.assignments (
    id uuid primary key default uuid_generate_v4 (),
    name text not null,
    grade numeric(5, 2) not null default 0,
    weight numeric(5, 2) not null default 0,
    weight_complex numeric(5,2),
    t boolean not null,
    course_id uuid not null references api.courses (id),
    created_at timestamp with time zone not null default now ()
);

create role web_anon nologin;

grant usage on schema api to web_anon;

grant
select
    on api.assignments to web_anon;

grant
select
    on api.courses to web_anon;

grant
select
    on api.users to web_anon;

create role authenticator noinherit login password 'I_KNOW_WHAT_I_AM_DOING';

grant web_anon to authenticator;
