defmodule Notes.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :content, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:notes, [:user_id])
  end
end
