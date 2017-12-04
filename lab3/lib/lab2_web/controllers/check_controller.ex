defmodule Lab2Web.CheckController do
  use Lab2Web, :controller

  alias Lab2.Checks
  alias Lab2.Checks.Check

  def index(conn, _params) do
    checks = Checks.list_checks()
    render(conn, "index.html", checks: checks)
  end

  def new(conn, _params) do
    changeset = Checks.change_check(%Check{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"check" => check_params}) do
    case Checks.create_check(check_params) do
      {:ok, check} ->
        conn
        |> put_flash(:info, "Check created successfully.")
        |> redirect(to: check_path(conn, :show, check))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    check = Checks.get_check!(id)
    render(conn, "show.html", check: check)
  end

  def edit(conn, %{"id" => id}) do
    check = Checks.get_check!(id)
    changeset = Checks.change_check(check)
    render(conn, "edit.html", check: check, changeset: changeset)
  end

  def update(conn, %{"id" => id, "check" => check_params}) do
    check = Checks.get_check!(id)

    case Checks.update_check(check, check_params) do
      {:ok, check} ->
        conn
        |> put_flash(:info, "Check updated successfully.")
        |> redirect(to: check_path(conn, :show, check))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", check: check, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    check = Checks.get_check!(id)
    {:ok, _check} = Checks.delete_check(check)

    conn
    |> put_flash(:info, "Check deleted successfully.")
    |> redirect(to: check_path(conn, :index))
  end
end
