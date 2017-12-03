defmodule Lab2.Authors.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lab2.Authors.Author


  schema "authors" do
    field :birth, :string
    field :name, :string
    field :rating, :integer
    field :surname, :string

    timestamps()
  end

  @doc false
  def changeset(%Author{} = author, attrs) do
    author
    |> cast(attrs, [ :birth, :name, :rating, :surname])
    |> validate_required([:birth, :name, :rating, :surname])
  end
end
