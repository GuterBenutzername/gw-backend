create schema api;

create extension if not exists "uuid-ossp";

create table
    api.assignments (
        id uuid primary key default uuid_generate_v4 (),
        name text not null,
        grade numeric(5, 2) not null default 0,
        weight numeric(5, 2) not null default 0,
        t boolean not null,
        created_at timestamp
        with
            time zone not null default now ()
    );

insert into
    api.assignments (name, grade, weight, t)
values
    ('Daily assignment', 75, 0.15, false),
    ('The bad quiz :(', 26, 0.25, false),
    ('Future test', 95, 0.65, true);

create role web_anon nologin;

grant usage on schema api to web_anon;

grant
select
    on api.assignments to web_anon;

create role authenticator noinherit login password 'I_KNOW_WHAT_I_AM_DOING';

grant web_anon to authenticator;