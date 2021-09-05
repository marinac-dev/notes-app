# Specs

## Goal

- Create a web API using Elixir, Phoenix, PostgreSQL, and the [JSON:API standard](https://jsonapi.org/)

## Features

- [x] User sign-in,
- [x] List notes,
- [x] Create a note,
- [x] Edit note,
- [x] Remove note,
- [x] Allow attaching files to a note,
- [x] Allow sharing notes with other users.

## Get started

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## How to use?

- You will need some API client

### Public auth scope

- Used for sign up/in, and has two routes and both are POST
- `/api/v1/auth/sign-in` and `/api/v1/auth/sign-up`
- Params for `/api/v1/auth/sign-in` and `/api/v1/auth/sign-up` are same
- Both will return either api key or error if you mess up something

```json
{
  "user": {
    "username": "some_username",
    "password": "TopS$cr$$t"
  }
}
```

### Private (requires auth) scope

- Used for crud operations on respective scope
- All of these routes ignore `:user_id` because it's extracted from `api_key` but it can be used to check if user wants to mess with url params so you can troll him :)
- Consists of following routes:
  - Users scope
  - `GET /api/v1/users/` returns list of all users
  - `GET /api/v1/users/:id` returns data of a signle user
  - `PATCH|PUT /api/v1/users/:id` updates user
    - Request body
    ```json
    {
      "user": {
        "username": "something_new",
        "password": "you dont't have to change me"
      }
    }
    ```
  - `DELETE /api/v1/users/:id` deletes user
  - Notes scope
  - `GET /api/v1/users/:user_id/shares` returns notes SHARED WITH USER
  - `GET /api/v1/users/:user_id/shared` returns notes SHARED BY USER
  - `POST /api/v1/users/:user_id/notes/:note_id/share` shares note with user
    - Request body
    ```json
    {
      "share": {
        "note_id": 1,
        "share_id": 1, // This is ID of user you want to share note to
      }
    }
    ```
  - `GET /api/v1/users/:user_id/notes` returns list notes OWNED BY USER
  - `GET /api/v1/users/:user_id/notes/:id` returns signle note
  - `POST /api/v1/users/:user_id/notes` creates user note
    - Request body
    ```json
    {
      "note": {
        "content": "My really awesome note"
      }
    }
    ```
  - `PATCH|PUT /api/v1/users/:user_id/notes/:id` updates note (same params as POST)
  - `DELETE /api/v1/users/:user_id/notes/:id` deletes note
  - Files scope
  - `GET /api/v1/users/:user_id/notes/:note_id/files` returns list of note's files
  - `GET /api/v1/users/:user_id/notes/:note_id/files/:id` returns specified note file
  - `POST /api/v1/users/:user_id/notes/:note_id/files` uploades file to note
  - `PATCH|PUT /api/v1/users/:user_id/notes/:note_id/files/:id` updates file
  - `DELETE /api/v1/users/:user_id/notes/:note_id/files/:id` deletes file from note


## ! Note (bugs)

- Session is vulnerable to token reuse (requires unique runtime salt)
- Session paths (sign in/up) is not redirected if authenticated (requires `redirect_if_authenticated`)
- Does not strictly follow JSON:API standard
- Error handling is not complete
- File is physically uploaded when note_id is invalid
- Auth routes are disabled in test env
