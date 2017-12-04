defmodule Lab2Web.AuthorController do
  use Lab2Web, :controller

  import Ecto.Query, warn: false
  alias Lab2.Repo

  alias Lab2.Authors
  alias Lab2.Authors.Author

  def index(conn, _params) do
    authors = Authors.list_authors()
    changeset = Authors.change_author(%Author{})
    render(conn, "index.html", [changeset: changeset,authors: authors])
  end

  def new(conn, _params) do
    changeset = Authors.change_author(%Author{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"author" => author_params}) do
    case Authors.create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author created successfully.")
        |> redirect(to: author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    author = Authors.get_author!(id)
    render(conn, "show.html", author: author)
  end

  def edit(conn, %{"id" => id}) do
    author = Authors.get_author!(id)
    changeset = Authors.change_author(author)
    render(conn, "edit.html", author: author, changeset: changeset)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Authors.get_author!(id)

    case Authors.update_author(author, author_params) do
      {:ok, author} ->
        conn
        |> put_flash(:info, "Author updated successfully.")
        |> redirect(to: author_path(conn, :show, author))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", author: author, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Authors.get_author!(id)
    {:ok, _author} = Authors.delete_author(author)

    conn
    |> put_flash(:info, "Author deleted successfully.")
    |> redirect(to: author_path(conn, :index))
  end

  def import(conn, %{"author" => author_params}) do
    author_params["author"].path
    |> File.stream!()
    |> CSV.decode!
    |> IO.inspect
    |> Enum.each(fn (author)-> Author.changeset(%Author{}, %{birth: Enum.at(author,0),name: Enum.at(author,1),surname: Enum.at(author,2),rating: Enum.at(author,3)}) |> Repo.insert end)
    conn
    |> put_flash(:info, "Imported")
    |> redirect(to: author_path(conn,:index))
  end

  def search(conn, %{"author" => author_params}) do
    changeset = Authors.change_author(%Author{})
    birth = if(author_params["birth"] != "",do: "LIKE \'#{author_params["birth"]}\'",else: "is not NULL")
    name = if(author_params["name"] != "",do: "LIKE \'#{author_params["name"]}\'",else: "is not NULL")
    surname = if(author_params["surname"] != "",do: "LIKE \'#{author_params["surname"]}\'",else: "is not NULL")
    rating = if(author_params["rating"] != "",do: "= #{author_params["rating"]}",else: "is not NULL")
    IO.inspect name
    {:ok, result} = Repo.query("select id,birth,name,surname from authors where birth #{birth} and name #{name} and surname #{surname} and rating #{rating}")
    authors = Enum.map result.rows, fn row ->
     Enum.zip(result.columns,row) 
     |> Enum.map(fn {key,val} -> {String.to_atom(key),val} end)
     |> Enum.into(%{})
     |> IO.inspect
     |> (&Kernel.struct(%Author{},&1)).()
    end
    render(conn,"result.html",[changeset: changeset, authors: authors])
  end
end
