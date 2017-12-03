defmodule Lab2.Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :description, :string
      add :name, :string

      timestamps()
    end

  end
end
