defmodule Notes.Accounts.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :content, :string
    has_many :files, Notes.Accounts.File
    belongs_to :user, Notes.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
  end
end
