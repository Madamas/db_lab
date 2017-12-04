defmodule Lab2.Mangas do
  @moduledoc """
  The Mangas context.
  """

  import Ecto.Query, warn: false
  alias Lab2.Repo

  alias Lab2.Mangas.Manga

  @doc """
  Returns the list of mangas.

  ## Examples

      iex> list_mangas()
      [%Manga{}, ...]

  """
  def list_mangas do
    Repo.all(Manga)
  end

  @doc """
  Gets a single manga.

  Raises `Ecto.NoResultsError` if the Manga does not exist.

  ## Examples

      iex> get_manga!(123)
      %Manga{}

      iex> get_manga!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manga!(id), do: Repo.get!(Manga, id)

  @doc """
  Creates a manga.

  ## Examples

      iex> create_manga(%{field: value})
      {:ok, %Manga{}}

      iex> create_manga(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manga(attrs \\ %{}) do
    %Manga{}
    |> Manga.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a manga.

  ## Examples

      iex> update_manga(manga, %{field: new_value})
      {:ok, %Manga{}}

      iex> update_manga(manga, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manga(%Manga{} = manga, attrs) do
    manga
    |> Manga.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Manga.

  ## Examples

      iex> delete_manga(manga)
      {:ok, %Manga{}}

      iex> delete_manga(manga)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manga(%Manga{} = manga) do
    Repo.delete(manga)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manga changes.

  ## Examples

      iex> change_manga(manga)
      %Ecto.Changeset{source: %Manga{}}

  """
  def change_manga(%Manga{} = manga) do
    Manga.changeset(manga, %{})
  end
end
