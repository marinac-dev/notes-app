defmodule NotesWeb.FileController do
  use NotesWeb, :controller

  alias Notes.Accounts
  alias Notes.Accounts.File

  action_fallback NotesWeb.FallbackController

  def index(conn, _params) do
    files = Accounts.list_files()
    render(conn, "index.json", files: files)
  end

  def create(%{assigns: %{user_id: user_id}} = conn, %{
        "file" => %{"name" => _, "extension" => _, "file_content" => _, "note_id" => _} = params
      }) do
    file_params = %{params | "user_id" => user_id}

    with {:ok, %File{} = file} <- Accounts.create_file(file_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.user_note_file_path(conn, :show, file.user_id, file.note_id, file)
      )
      |> render("show.json", file: file)
    end
  end

  def show(conn, %{"id" => id}) do
    file = Accounts.get_file!(id)
    render(conn, "show.json", file: file)
  end

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Accounts.get_file!(id)

    with {:ok, %File{} = file} <- Accounts.update_file(file, file_params) do
      render(conn, "show.json", file: file)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Accounts.get_file!(id)

    with {:ok, %File{}} <- Accounts.delete_file(file) do
      send_resp(conn, :no_content, "")
    end
  end
end
