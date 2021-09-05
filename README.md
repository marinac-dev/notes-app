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

## ! Note (bugs)

- Session is vulnerable to token reuse (requires unique runtime salt)
- Session paths (sign in/up) is not redirected if authenticated (requires `redirect_if_authenticated`)
- Does not strictly follow JSON:API standard
- Error handling is not complete
- File is physically uploaded when note_id is invalid
- Auth routes are disabled in test env
