defmodule Lab2.Mangas.Manga do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lab2.Mangas.Manga


  schema "mangas" do
    field :author_id, :integer
    field :genre_id, :integer
    field :publisher_id, :integer
    field :score, :integer

    timestamps()
  end

  @doc false
  def changeset(%Manga{} = manga, attrs) do
    manga
    |> cast(attrs, [:score,:author_id,:genre_id,:publisher_id])
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:genre_id)
    |> foreign_key_constraint(:publisher_id)
    |> validate_required([:score,:author_id,:genre_id,:publisher_id])
  end
end
