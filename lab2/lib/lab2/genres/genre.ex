defmodule Lab2.Genres.Genre do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lab2.Genres.Genre


  schema "genres" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Genre{} = genre, attrs) do
    genre
    |> cast(attrs, [:description, :name])
    |> validate_required([:description, :name])
  end
end
