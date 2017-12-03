defmodule Lab2.PublishersTest do
  use Lab2.DataCase

  alias Lab2.Publishers

  describe "publishers" do
    alias Lab2.Publishers.Publisher

    @valid_attrs %{city: "some city", country: "some country", name: "some name", rating: 42}
    @update_attrs %{city: "some updated city", country: "some updated country", name: "some updated name", rating: 43}
    @invalid_attrs %{city: nil, country: nil, name: nil, rating: nil}

    def publisher_fixture(attrs \\ %{}) do
      {:ok, publisher} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Publishers.create_publisher()

      publisher
    end

    test "list_publishers/0 returns all publishers" do
      publisher = publisher_fixture()
      assert Publishers.list_publishers() == [publisher]
    end

    test "get_publisher!/1 returns the publisher with given id" do
      publisher = publisher_fixture()
      assert Publishers.get_publisher!(publisher.id) == publisher
    end

    test "create_publisher/1 with valid data creates a publisher" do
      assert {:ok, %Publisher{} = publisher} = Publishers.create_publisher(@valid_attrs)
      assert publisher.city == "some city"
      assert publisher.country == "some country"
      assert publisher.name == "some name"
      assert publisher.rating == 42
    end

    test "create_publisher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Publishers.create_publisher(@invalid_attrs)
    end

    test "update_publisher/2 with valid data updates the publisher" do
      publisher = publisher_fixture()
      assert {:ok, publisher} = Publishers.update_publisher(publisher, @update_attrs)
      assert %Publisher{} = publisher
      assert publisher.city == "some updated city"
      assert publisher.country == "some updated country"
      assert publisher.name == "some updated name"
      assert publisher.rating == 43
    end

    test "update_publisher/2 with invalid data returns error changeset" do
      publisher = publisher_fixture()
      assert {:error, %Ecto.Changeset{}} = Publishers.update_publisher(publisher, @invalid_attrs)
      assert publisher == Publishers.get_publisher!(publisher.id)
    end

    test "delete_publisher/1 deletes the publisher" do
      publisher = publisher_fixture()
      assert {:ok, %Publisher{}} = Publishers.delete_publisher(publisher)
      assert_raise Ecto.NoResultsError, fn -> Publishers.get_publisher!(publisher.id) end
    end

    test "change_publisher/1 returns a publisher changeset" do
      publisher = publisher_fixture()
      assert %Ecto.Changeset{} = Publishers.change_publisher(publisher)
    end
  end
end
