create schema basic_auth;

-- We put things inside the basic_auth schema to hide
-- them from public view. Certain public procs/views will
-- refer to helpers and tables inside.
create table
    basic_auth.users (
        email text primary key check (email ~* '^.+@.+\..+$'),
        pass text not null check (length(pass) < 512),
        role name not null check (length(role) < 512)
    );

create function basic_auth.check_role_exists () returns trigger as $$
begin
  if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
    raise foreign_key_violation using message =
      'unknown database role: ' || new.role;
    return null;
  end if;
  return new;
end
$$ language plpgsql;

create constraint trigger ensure_user_role_exists
after insert
or
update on basic_auth.users for each row
execute procedure basic_auth.check_role_exists ();

create extension pgcrypto;
create extension pgjwt;

create function basic_auth.encrypt_pass () returns trigger as $$
begin
  if tg_op = 'INSERT' or new.pass <> old.pass then
    new.pass = crypt(new.pass, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

create trigger encrypt_pass before insert
or
update on basic_auth.users for each row
execute procedure basic_auth.encrypt_pass ();

create function basic_auth.user_role (email text, pass text) returns name language plpgsql as $$
begin
  return (
  select role from basic_auth.users
   where users.email = user_role.email
     and users.pass = crypt(user_role.pass, users.pass)
  );
end;
$$;

-- login should be on your exposed schema
create function api.login (email text, pass text, out token text) as $$
declare
  _role name;
begin
  -- check email and password
  select basic_auth.user_role(email, pass) into _role;
  if _role is null then
    raise invalid_password using message = 'invalid user or password';
  end if;

  select sign(
      row_to_json(r), 'asldkfjasldkfjalksdfjkasjkd'
    ) as token
    from (
      select _role as role, login.email as email,
         extract(epoch from now())::integer + 60*60 as exp
    ) r
    into token;
end;
$$ language plpgsql security definer;

grant
execute on function api.login (text, text) to web_anon;

create role aycii;

grant all on api.courses to aycii;

grant all on api.assignments to aycii;

insert into
    basic_auth.users (email, pass, role)
values
    ('aycii@gw.com', 'password', 'aycii');

ALTER DATABASE gw
SET
    "app.jwt_secret" TO '1234908120394810293481029384102934810294380914892034';