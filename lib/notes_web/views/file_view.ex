defmodule NotesWeb.FileView do
  use NotesWeb, :view
  alias NotesWeb.FileView

  def render("index.json", %{files: files}) do
    %{data: render_many(files, FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{data: render_one(file, FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{id: file.id, path: file.path, name: file.name, extension: file.extension, type: "file"}
  end
end
