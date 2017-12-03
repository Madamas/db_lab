defmodule Lab2Web.LabController do
	use Lab2Web, :controller

	def index(conn, _params) do
		#changeset = File.change_file(%File{})
		render conn, "index.html"
	end

	def show(conn, %{"context" => context}) do
		render conn, "show.html", context: context
	end
end