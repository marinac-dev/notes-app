defmodule NotesWeb.NoteView do
  use NotesWeb, :view
  alias NotesWeb.{NoteView, FileView}

  def render("index.json", %{notes: notes}) do
    %{data: render_many(notes, NoteView, "note.json")}
  end

  def render("show.json", %{note: note}) do
    %{data: render_one(note, NoteView, "note.json")}
  end

  def render("note.json", %{note: note}) do
    %{
      id: note.id,
      type: "note",
      content: note.content,
      files: FileView.render("index.json", files: note.files)
    }
  end
end
