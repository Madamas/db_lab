defmodule Lab2.Repo.Migrations.CreateChecks do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :manga_id, :integer
      add :insert_date, :date
      add :insert_time, :time

      timestamps()
    end

  end
end
