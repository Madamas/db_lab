defmodule Lab2.Checks do
  @moduledoc """
  The Checks context.
  """

  import Ecto.Query, warn: false
  alias Lab2.Repo

  alias Lab2.Checks.Check

  @doc """
  Returns the list of checks.

  ## Examples

      iex> list_checks()
      [%Check{}, ...]

  """
  def list_checks do
    Repo.all(Check)
  end

  @doc """
  Gets a single check.

  Raises `Ecto.NoResultsError` if the Check does not exist.

  ## Examples

      iex> get_check!(123)
      %Check{}

      iex> get_check!(456)
      ** (Ecto.NoResultsError)

  """
  def get_check!(id), do: Repo.get!(Check, id)

  @doc """
  Creates a check.

  ## Examples

      iex> create_check(%{field: value})
      {:ok, %Check{}}

      iex> create_check(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_check(attrs \\ %{}) do
    %Check{}
    |> Check.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a check.

  ## Examples

      iex> update_check(check, %{field: new_value})
      {:ok, %Check{}}

      iex> update_check(check, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_check(%Check{} = check, attrs) do
    check
    |> Check.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Check.

  ## Examples

      iex> delete_check(check)
      {:ok, %Check{}}

      iex> delete_check(check)
      {:error, %Ecto.Changeset{}}

  """
  def delete_check(%Check{} = check) do
    Repo.delete(check)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking check changes.

  ## Examples

      iex> change_check(check)
      %Ecto.Changeset{source: %Check{}}

  """
  def change_check(%Check{} = check) do
    Check.changeset(check, %{})
  end
end
