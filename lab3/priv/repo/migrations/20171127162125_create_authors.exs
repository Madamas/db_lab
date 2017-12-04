defmodule Lab2.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :birth, :string
      add :name, :string
      add :rating, :integer
      add :surname, :string

      timestamps()
    end

  end
end
