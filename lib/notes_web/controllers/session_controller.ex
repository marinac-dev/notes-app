defmodule NotesWeb.SessionController do
  use NotesWeb, :controller

  alias NotesWeb.Plugin.Auth
  alias Notes.{Accounts, Accounts.User}

  action_fallback NotesWeb.FallbackController

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      api_token = Auth.generate_token(user.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", session: api_token)
    end
  end

  def sign_up(conn, _params) do
    conn |> put_status(400) |> json(%{data: "Bad register params"})
  end

  def sign_in(conn, %{"user" => user_params}) do
    %{"username" => username, "password" => password} = user_params

    case Accounts.get_user_by_username_and_password(username, password) do
      %User{} = user ->
        api_token = Auth.generate_token(user.id)

        conn
        |> put_status(200)
        |> put_resp_header("location", Routes.user_path(conn, :show, user))
        |> render("show.json", session: api_token)

      nil ->
        conn |> put_status(401) |> json(%{data: "Invalid username or password."})
    end
  end

  def sign_in(conn, _params) do
    conn |> put_status(400) |> json(%{data: "Bad login params"})
  end
end
