defmodule NotesWeb.ShareController do
  use NotesWeb, :controller

  alias Notes.{Accounts, Accounts.Share}

  action_fallback NotesWeb.FallbackController

  def shares(%{assigns: %{user_id: user_id}} = conn, _) do
    shares = Accounts.get_shares_by_user(user_id)
    render(conn, "index.json", shares: shares)
  end

  def index(%{assigns: %{user_id: user_id}} = conn, _) do
    shares = Accounts.get_shares_for_user(user_id)
    IO.inspect(shares)
    render(conn, "index.json", shares: shares)
  end

  def create(%{assigns: %{user_id: user_id}} = conn, %{"share" => share_params}) do
    with {:ok, %Share{} = share} <- Accounts.create_share(share_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_share_path(conn, :show, user_id, share))
      |> render("show.json", share: share)
    end
  end
end
