defmodule Lab2.Files.File do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lab2.Files.File


  schema "files" do
    field :file, :string

    timestamps()
  end

  @doc false
  def changeset(%File{} = file, attrs) do
    file
    |> cast(attrs, [:file])
    |> validate_required([:file])
  end
end
