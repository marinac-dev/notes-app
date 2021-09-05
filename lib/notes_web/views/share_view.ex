defmodule NotesWeb.ShareView do
  use NotesWeb, :view
  alias NotesWeb.{NoteView, ShareView, UserView}

  def render("index.json", %{shares: shares}) do
    %{data: render_many(shares, ShareView, "share.json")}
  end

  def render("show.json", %{share: share}) do
    %{data: render_one(share, ShareView, "share.json")}
  end

  def render("share.json", %{share: share}) do
    %{
      type: "share",
      owner: UserView.render("show.json", user: share.owner),
      data: NoteView.render("show.json", note: share.note)
    }
  end
end
