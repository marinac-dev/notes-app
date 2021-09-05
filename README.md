# Specs

## Goal

- Create a web API using Elixir, Phoenix, PostgreSQL, and the [JSON:API standard](https://jsonapi.org/)

## Features

- [x] User sign-in,
- [x] List notes,
- [x] Create a note,
- [x] Edit note,
- [x] Remove note,
- [ ] Allow attaching files to a note,
- [ ] Allow sharing notes with other users.

## Get started

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## ! Note

- Session is vulnerable to token reuse
- Session paths (sign in/up) is not redirected if authenticated