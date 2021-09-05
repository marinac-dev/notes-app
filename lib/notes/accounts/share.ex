defmodule Notes.Accounts.Share do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shares" do
    belongs_to :owner, Notes.Accounts.User
    belongs_to :share, Notes.Accounts.User
    belongs_to :note, Notes.Accounts.Note

    timestamps()
  end

  @doc false
  def changeset(share, attrs) do
    share
    |> cast(attrs, [:note_id, :owner_id, :share_id])
    |> validate_required([:note_id, :owner_id, :share_id])
  end
end
