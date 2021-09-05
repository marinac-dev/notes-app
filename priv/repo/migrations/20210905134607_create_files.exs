defmodule Notes.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :path, :string
      add :name, :string
      add :extension, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :note_id, references(:notes, on_delete: :nothing)

      timestamps()
    end

    create index(:files, [:user_id])
    create index(:files, [:note_id])
  end
end
