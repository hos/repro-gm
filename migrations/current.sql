drop table if exists public.users;

create table public.users (
  id bigint generated always as identity primary key
);
