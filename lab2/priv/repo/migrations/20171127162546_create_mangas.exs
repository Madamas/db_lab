defmodule Lab2.Repo.Migrations.CreateMangas do
  use Ecto.Migration

  def change do
    create table(:mangas) do
      add :author_id, references(:authors, on_delete: :delete_all)
      add :genre_id, references(:genres, on_delete: :delete_all)
      add :publisher_id, references(:publishers, on_delete: :delete_all)
      add :score, :integer

      timestamps()
    end

    # alter table(:mangas) do
    #   modify :author_id, references(:authors, on_delete: :delete_all)
    #   modify :publisher_id, references(:publishers, on_delete: :delete_all)
    #   modify :genre_id, references(:genres, on_delete: :delete_all)
    # end
  end
end
