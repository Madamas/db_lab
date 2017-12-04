defmodule Lab2.Checks.Check do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lab2.Checks.Check


  schema "checks" do
    field :insert_date, :date
    field :insert_time, :time
    field :manga_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Check{} = check, attrs) do
    check
    |> cast(attrs, [:manga_id, :insert_date, :insert_time])
    |> validate_required([:manga_id, :insert_date, :insert_time])
  end
end
