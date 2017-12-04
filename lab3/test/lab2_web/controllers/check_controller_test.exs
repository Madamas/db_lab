defmodule Lab2Web.CheckControllerTest do
  use Lab2Web.ConnCase

  alias Lab2.Checks

  @create_attrs %{insert_date: ~D[2010-04-17], insert_time: ~T[14:00:00.000000], manga_id: 42}
  @update_attrs %{insert_date: ~D[2011-05-18], insert_time: ~T[15:01:01.000000], manga_id: 43}
  @invalid_attrs %{insert_date: nil, insert_time: nil, manga_id: nil}

  def fixture(:check) do
    {:ok, check} = Checks.create_check(@create_attrs)
    check
  end

  describe "index" do
    test "lists all checks", %{conn: conn} do
      conn = get conn, check_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Checks"
    end
  end

  describe "new check" do
    test "renders form", %{conn: conn} do
      conn = get conn, check_path(conn, :new)
      assert html_response(conn, 200) =~ "New Check"
    end
  end

  describe "create check" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, check_path(conn, :create), check: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == check_path(conn, :show, id)

      conn = get conn, check_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Check"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, check_path(conn, :create), check: @invalid_attrs
      assert html_response(conn, 200) =~ "New Check"
    end
  end

  describe "edit check" do
    setup [:create_check]

    test "renders form for editing chosen check", %{conn: conn, check: check} do
      conn = get conn, check_path(conn, :edit, check)
      assert html_response(conn, 200) =~ "Edit Check"
    end
  end

  describe "update check" do
    setup [:create_check]

    test "redirects when data is valid", %{conn: conn, check: check} do
      conn = put conn, check_path(conn, :update, check), check: @update_attrs
      assert redirected_to(conn) == check_path(conn, :show, check)

      conn = get conn, check_path(conn, :show, check)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, check: check} do
      conn = put conn, check_path(conn, :update, check), check: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Check"
    end
  end

  describe "delete check" do
    setup [:create_check]

    test "deletes chosen check", %{conn: conn, check: check} do
      conn = delete conn, check_path(conn, :delete, check)
      assert redirected_to(conn) == check_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, check_path(conn, :show, check)
      end
    end
  end

  defp create_check(_) do
    check = fixture(:check)
    {:ok, check: check}
  end
end
