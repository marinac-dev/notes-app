defmodule Notes.Repo do
  use Ecto.Repo,
    otp_app: :notes,
    adapter: Ecto.Adapters.Postgres
end
