defmodule Lab2.Repo.Migrations.CreatePublishers do
  use Ecto.Migration

  def change do
    create table(:publishers) do
      add :city, :string
      add :country, :string
      add :name, :string
      add :rating, :integer

      timestamps()
    end

  end
end
