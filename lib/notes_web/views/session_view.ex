defmodule NotesWeb.SessionView do
  use NotesWeb, :view
  alias NotesWeb.SessionView

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{type: "session", session: session}
  end
end
