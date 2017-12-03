defmodule Lab2Web.GenreController do
  use Lab2Web, :controller

  import Ecto.Query, warn: false
  alias Lab2.Repo

  alias Lab2.Genres
  alias Lab2.Genres.Genre

  def index(conn, _params) do
    genres = Genres.list_genres()
    changeset = Genres.change_genre(%Genre{})
    render(conn, "index.html", [changeset: changeset,genres: genres])
  end

  def new(conn, _params) do
    changeset = Genres.change_genre(%Genre{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"genre" => genre_params}) do
    case Genres.create_genre(genre_params) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre created successfully.")
        |> redirect(to: genre_path(conn, :show, genre))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    genre = Genres.get_genre!(id)
    render(conn, "show.html", genre: genre)
  end

  def edit(conn, %{"id" => id}) do
    genre = Genres.get_genre!(id)
    changeset = Genres.change_genre(genre)
    render(conn, "edit.html", genre: genre, changeset: changeset)
  end

  def update(conn, %{"id" => id, "genre" => genre_params}) do
    genre = Genres.get_genre!(id)

    case Genres.update_genre(genre, genre_params) do
      {:ok, genre} ->
        conn
        |> put_flash(:info, "Genre updated successfully.")
        |> redirect(to: genre_path(conn, :show, genre))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", genre: genre, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    genre = Genres.get_genre!(id)
    {:ok, _genre} = Genres.delete_genre(genre)

    conn
    |> put_flash(:info, "Genre deleted successfully.")
    |> redirect(to: genre_path(conn, :index))
  end

  def import(conn, %{"genre" => genre_params}) do
    genre_params["genre"].path
    |> File.stream!()
    |> CSV.decode!
    |> IO.inspect
    |> Enum.each(fn (genre)-> Genre.changeset(%Genre{}, %{description: Enum.at(genre,0),name: Enum.at(genre,1)}) |> Repo.insert end)
    conn
    |> put_flash(:info, "Imported")
    |> redirect(to: genre_path(conn,:index))
  end

  def search(conn, %{"genre" => genre_params}) do
    changeset = Genres.change_genre(%Genre{})
    description = if(genre_params["description"] != "",do: "LIKE \'#{genre_params["description"]}\'",else: "is not NULL")
    name = if(genre_params["name"] != "",do: "LIKE \'#{genre_params["name"]}\'",else: "is not NULL")
    IO.inspect name
    {:ok, result} = Repo.query("select id,description,name from genres where description #{description} and name #{name}")
    genres = Enum.map result.rows, fn row ->
     Enum.zip(result.columns,row) 
     |> Enum.map(fn {key,val} -> {String.to_atom(key),val} end)
     |> Enum.into(%{})
     |> IO.inspect
     |> (&Kernel.struct(%Genre{},&1)).()
    end
    render(conn,"result.html",[changeset: changeset, genres: genres])
  end
end
