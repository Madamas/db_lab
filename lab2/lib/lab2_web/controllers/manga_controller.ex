defmodule Lab2Web.MangaController do
  use Lab2Web, :controller

  import Ecto.Query, warn: false
  alias Lab2.Repo

  alias Lab2.Mangas
  alias Lab2.Mangas.Manga

  def index(conn, _params) do
    mangas = Mangas.list_mangas()
    changeset = Mangas.change_manga(%Manga{})
    IO.inspect mangas,label: "kek "
    render(conn, "index.html", [changeset: changeset,mangas: mangas])
  end

  def new(conn, _params) do
    changeset = Mangas.change_manga(%Manga{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"manga" => manga_params}) do
    case Mangas.create_manga(manga_params) do
      {:ok, manga} ->
        conn
        |> put_flash(:info, "Manga created successfully.")
        |> redirect(to: manga_path(conn, :show, manga))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    manga = Mangas.get_manga!(id)
    render(conn, "show.html", manga: manga)
  end

  def edit(conn, %{"id" => id}) do
    manga = Mangas.get_manga!(id)
    changeset = Mangas.change_manga(manga)
    render(conn, "edit.html", manga: manga, changeset: changeset)
  end

  def update(conn, %{"id" => id, "manga" => manga_params}) do
    manga = Mangas.get_manga!(id)

    case Mangas.update_manga(manga, manga_params) do
      {:ok, manga} ->
        conn
        |> put_flash(:info, "Manga updated successfully.")
        |> redirect(to: manga_path(conn, :show, manga))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", manga: manga, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    manga = Mangas.get_manga!(id)
    {:ok, _manga} = Mangas.delete_manga(manga)

    conn
    |> put_flash(:info, "Manga deleted successfully.")
    |> redirect(to: manga_path(conn, :index))
  end

  def import(conn, %{"manga" => manga_params}) do
    manga_params["manga"].path
    |> File.stream!()
    |> CSV.decode!
    |> IO.inspect
    |> Enum.each(fn (manga)-> Manga.changeset(%Manga{}, %{score: Enum.at(manga,0),author_id: Enum.at(manga,1),genre_id: Enum.at(manga,2),publisher_id: Enum.at(manga,3)}) |> Repo.insert end)
    conn
    |> put_flash(:info, "Imported")
    |> redirect(to: manga_path(conn,:index))
  end

  def search(conn, %{"manga" => manga_params}) do
    changeset = Mangas.change_manga(%Manga{})
    author = if(manga_params["author_id"] != "",do: "= #{manga_params["author_id"]}",else: "is not NULL")
    genre = if(manga_params["genre_id"] != "",do: "= #{manga_params["genre_id"]}",else: "is not NULL")
    publisher = if(manga_params["publisher_id"] != "",do: "= #{manga_params["publisher_id"]}",else: "is not NULL")
    score = if(manga_params["score"] != "",do: " = #{manga_params["score"]}",else: "is not NULL")
    {:ok, result} = Repo.query("select id,author_id,genre_id,publisher_id,score from mangas where author_id #{author} and genre_id #{genre} and publisher_id #{publisher} and score #{score}")
    mangas = Enum.map result.rows, fn row ->
     Enum.zip(result.columns,row) 
     |> Enum.map(fn {key,val} -> {String.to_atom(key),val} end)
     |> Enum.into(%{})
     |> IO.inspect
     |> (&Kernel.struct(%Manga{},&1)).()
    end
    render(conn,"result.html",[changeset: changeset, mangas: mangas])
  end
end