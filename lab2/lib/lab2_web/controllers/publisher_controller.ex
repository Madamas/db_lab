defmodule Lab2Web.PublisherController do
  use Lab2Web, :controller

  import Ecto.Query, warn: false
  alias Lab2.Repo

  alias Lab2.Publishers
  alias Lab2.Publishers.Publisher

  def index(conn, _params) do
    publishers = Publishers.list_publishers()
    changeset = Publishers.change_publisher(%Publisher{})
    render(conn, "index.html", [changeset: changeset,publishers: publishers])
  end

  def new(conn, _params) do
    changeset = Publishers.change_publisher(%Publisher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"publisher" => publisher_params}) do
    case Publishers.create_publisher(publisher_params) do
      {:ok, publisher} ->
        conn
        |> put_flash(:info, "Publisher created successfully.")
        |> redirect(to: publisher_path(conn, :show, publisher))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    publisher = Publishers.get_publisher!(id)
    render(conn, "show.html", publisher: publisher)
  end

  def edit(conn, %{"id" => id}) do
    publisher = Publishers.get_publisher!(id)
    changeset = Publishers.change_publisher(publisher)
    render(conn, "edit.html", publisher: publisher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "publisher" => publisher_params}) do
    publisher = Publishers.get_publisher!(id)

    case Publishers.update_publisher(publisher, publisher_params) do
      {:ok, publisher} ->
        conn
        |> put_flash(:info, "Publisher updated successfully.")
        |> redirect(to: publisher_path(conn, :show, publisher))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", publisher: publisher, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    publisher = Publishers.get_publisher!(id)
    {:ok, _publisher} = Publishers.delete_publisher(publisher)

    conn
    |> put_flash(:info, "Publisher deleted successfully.")
    |> redirect(to: publisher_path(conn, :index))
  end

  def import(conn, %{"publisher" => publisher_params}) do
    publisher_params["publisher"].path
    |> File.stream!()
    |> CSV.decode!
    |> IO.inspect
    |> Enum.each(fn (publisher)-> Publisher.changeset(%Publisher{}, %{city: Enum.at(publisher,0),country: Enum.at(publisher,1),name: Enum.at(publisher,2),rating: Enum.at(publisher,3)}) |> Repo.insert end)
    conn
    |> put_flash(:info, "Imported")
    |> redirect(to: publisher_path(conn,:index))
  end

  def search(conn, %{"publisher" => publisher_params}) do
    changeset = Publishers.change_publisher(%Publisher{})
    city = if(publisher_params["city"] != "",do: "LIKE \'#{publisher_params["city"]}\'",else: "is not NULL")
    country = if(publisher_params["country"] != "",do: "LIKE \'#{publisher_params["country"]}\'",else: "is not NULL")
    name = if(publisher_params["name"] != "",do: "LIKE \'#{publisher_params["name"]}\'",else: "is not NULL")
    rating = if(publisher_params["rating"] != "",do: " = #{publisher_params["rating"]}",else: "is not NULL")
    IO.inspect("select id,city,country,name,rating from publishers where city #{city} and country #{country} and name #{name} and rating #{rating}",label: "oy lol")
    {:ok, result} = Repo.query("select id,city,country,name,rating from publishers where city #{city} and country #{country} and name #{name} and rating #{rating}")
    publishers = Enum.map result.rows, fn row ->
     Enum.zip(result.columns,row) 
     |> Enum.map(fn {key,val} -> {String.to_atom(key),val} end)
     |> Enum.into(%{})
     |> IO.inspect
     |> (&Kernel.struct(%Publisher{},&1)).()
    end
    render(conn,"result.html",[changeset: changeset, publishers: publishers])
  end
end
