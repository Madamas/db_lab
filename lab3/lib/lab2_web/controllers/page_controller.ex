defmodule Lab2Web.PageController do
  use Lab2Web, :controller

  import Ecto.Query, warn: false
  alias Lab2.Repo

  def index(conn, _params) do
    render conn, "index.html"
  end

  def trigger_en(conn, _params) do
  	query = "alter table mangas enable trigger last_insert"
  	Repo.query(query)
  	render conn, "index.html"
  end

  def trigger_dis(conn, _params) do
  	query = "alter table mangas disable trigger last_insert"
  	IO.inspect Repo.query(query) ,label: "oy wey"
  	render conn, "index.html"
  end
end
