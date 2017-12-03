defmodule Lab2.Publishers.Publisher do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lab2.Publishers.Publisher


  schema "publishers" do
    field :city, :string
    field :country, :string
    field :name, :string
    field :rating, :integer

    timestamps()
  end

  @doc false
  def changeset(%Publisher{} = publisher, attrs) do
    publisher
    |> cast(attrs, [:city, :country, :name, :rating])
    |> validate_required([:city, :country, :name, :rating])
  end
end
