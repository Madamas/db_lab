defmodule Lab2Web.MangaControllerTest do
  use Lab2Web.ConnCase

  alias Lab2.Mangas

  @create_attrs %{author_id: 42, genre_id: 42, publisher_id: 42, score: 42}
  @update_attrs %{author_id: 43, genre_id: 43, publisher_id: 43, score: 43}
  @invalid_attrs %{author_id: nil, genre_id: nil, publisher_id: nil, score: nil}

  def fixture(:manga) do
    {:ok, manga} = Mangas.create_manga(@create_attrs)
    manga
  end

  describe "index" do
    test "lists all mangas", %{conn: conn} do
      conn = get conn, manga_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Mangas"
    end
  end

  describe "new manga" do
    test "renders form", %{conn: conn} do
      conn = get conn, manga_path(conn, :new)
      assert html_response(conn, 200) =~ "New Manga"
    end
  end

  describe "create manga" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, manga_path(conn, :create), manga: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == manga_path(conn, :show, id)

      conn = get conn, manga_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Manga"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, manga_path(conn, :create), manga: @invalid_attrs
      assert html_response(conn, 200) =~ "New Manga"
    end
  end

  describe "edit manga" do
    setup [:create_manga]

    test "renders form for editing chosen manga", %{conn: conn, manga: manga} do
      conn = get conn, manga_path(conn, :edit, manga)
      assert html_response(conn, 200) =~ "Edit Manga"
    end
  end

  describe "update manga" do
    setup [:create_manga]

    test "redirects when data is valid", %{conn: conn, manga: manga} do
      conn = put conn, manga_path(conn, :update, manga), manga: @update_attrs
      assert redirected_to(conn) == manga_path(conn, :show, manga)

      conn = get conn, manga_path(conn, :show, manga)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, manga: manga} do
      conn = put conn, manga_path(conn, :update, manga), manga: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Manga"
    end
  end

  describe "delete manga" do
    setup [:create_manga]

    test "deletes chosen manga", %{conn: conn, manga: manga} do
      conn = delete conn, manga_path(conn, :delete, manga)
      assert redirected_to(conn) == manga_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, manga_path(conn, :show, manga)
      end
    end
  end

  defp create_manga(_) do
    manga = fixture(:manga)
    {:ok, manga: manga}
  end
end
