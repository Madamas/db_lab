defmodule Lab2Web.Router do
  use Lab2Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lab2Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/root_test", RootTestController, :index
    resources "/authors", AuthorController
    post "/authors/import", AuthorController, :import
    post "/authors/search", AuthorController, :search
    resources "/genres", GenreController
    post "/genres/import", GenreController, :import
    post "/genres/search", GenreController, :search
    resources "/publishers", PublisherController
    post "/publishers/import", PublisherController, :import
    post "/publishers/search", PublisherController, :search
    resources "/mangas", MangaController
    post "/mangas/import", MangaController, :import
    post "/mangas/search", MangaController, :search
    resources "/lab/users", UserController
    resources "/reviews", ReviewController
  end
  scope "/admin", as: :admin do
    pipe_through :browser

    resources "/reviews", Lab2Web.Admin.ReviewController
  end

  scope "/" do
  #  pipe_through [:authenticate_user, :ensure_admin]
    forward "/jobs", BackgroundJob.Plug, name: "kekbung"
  end

  # Other scopes may use custom stacks.
  # scope "/api", Lab2Web do
  #   pipe_through :api
  # end
end
