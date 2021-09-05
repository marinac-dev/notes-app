defmodule NotesWeb.NoteController do
  use NotesWeb, :controller

  alias Notes.Accounts
  alias Notes.Accounts.Note

  action_fallback NotesWeb.FallbackController

  def index(conn, _params) do
    notes = Accounts.list_notes()
    render(conn, "index.json", notes: notes)
  end

  def create(conn, %{"note" => note_params}) do
    with {:ok, %Note{} = note} <- Accounts.create_note(note_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_note_path(conn, :show, note))
      |> render("show.json", note: note)
    end
  end

  def show(conn, %{"id" => id}) do
    note = Accounts.get_note!(id)
    render(conn, "show.json", note: note)
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    note = Accounts.get_note!(id)

    with {:ok, %Note{} = note} <- Accounts.update_note(note, note_params) do
      render(conn, "show.json", note: note)
    end
  end

  def delete(conn, %{"id" => id}) do
    note = Accounts.get_note!(id)

    with {:ok, %Note{}} <- Accounts.delete_note(note) do
      send_resp(conn, :no_content, "")
    end
  end
end
