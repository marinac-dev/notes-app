defmodule Notes.Accounts.File do
  use Ecto.Schema
  import Ecto.Changeset

  schema "files" do
    field :extension, :string
    field :name, :string
    field :path, :string

    belongs_to :users, Notes.Accounts.User
    belongs_to :notes, Notes.Accounts.Note

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:path, :name, :extension, :user_id, :note_id])
    |> validate_required([:path, :name, :extension, :user_id, :note_id])
  end
end
