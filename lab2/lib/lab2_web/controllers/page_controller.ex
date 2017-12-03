defmodule Lab2Web.PageController do
  use Lab2Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
