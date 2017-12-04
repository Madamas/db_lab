defmodule Lab2.ChecksTest do
  use Lab2.DataCase

  alias Lab2.Checks

  describe "checks" do
    alias Lab2.Checks.Check

    @valid_attrs %{insert_date: ~D[2010-04-17], insert_time: ~T[14:00:00.000000], manga_id: 42}
    @update_attrs %{insert_date: ~D[2011-05-18], insert_time: ~T[15:01:01.000000], manga_id: 43}
    @invalid_attrs %{insert_date: nil, insert_time: nil, manga_id: nil}

    def check_fixture(attrs \\ %{}) do
      {:ok, check} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Checks.create_check()

      check
    end

    test "list_checks/0 returns all checks" do
      check = check_fixture()
      assert Checks.list_checks() == [check]
    end

    test "get_check!/1 returns the check with given id" do
      check = check_fixture()
      assert Checks.get_check!(check.id) == check
    end

    test "create_check/1 with valid data creates a check" do
      assert {:ok, %Check{} = check} = Checks.create_check(@valid_attrs)
      assert check.insert_date == ~D[2010-04-17]
      assert check.insert_time == ~T[14:00:00.000000]
      assert check.manga_id == 42
    end

    test "create_check/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checks.create_check(@invalid_attrs)
    end

    test "update_check/2 with valid data updates the check" do
      check = check_fixture()
      assert {:ok, check} = Checks.update_check(check, @update_attrs)
      assert %Check{} = check
      assert check.insert_date == ~D[2011-05-18]
      assert check.insert_time == ~T[15:01:01.000000]
      assert check.manga_id == 43
    end

    test "update_check/2 with invalid data returns error changeset" do
      check = check_fixture()
      assert {:error, %Ecto.Changeset{}} = Checks.update_check(check, @invalid_attrs)
      assert check == Checks.get_check!(check.id)
    end

    test "delete_check/1 deletes the check" do
      check = check_fixture()
      assert {:ok, %Check{}} = Checks.delete_check(check)
      assert_raise Ecto.NoResultsError, fn -> Checks.get_check!(check.id) end
    end

    test "change_check/1 returns a check changeset" do
      check = check_fixture()
      assert %Ecto.Changeset{} = Checks.change_check(check)
    end
  end
end
