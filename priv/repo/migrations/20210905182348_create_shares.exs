defmodule Notes.Repo.Migrations.CreateShares do
  use Ecto.Migration

  def change do
    create table(:shares) do
      add :owner_id, references(:users, on_delete: :delete_all)
      add :share_id, references(:users, on_delete: :nothing)
      add :note_id, references(:notes, on_delete: :delete_all)

      timestamps()
    end

    create index(:shares, [:owner_id])
    create index(:shares, [:share_id])
    create index(:shares, [:note_id])
  end
end
