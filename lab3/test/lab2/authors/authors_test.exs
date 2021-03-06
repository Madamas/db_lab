defmodule Lab2.AuthorsTest do
  use Lab2.DataCase

  alias Lab2.Authors

  describe "authors" do
    alias Lab2.Authors.Author

    @valid_attrs %{birth: "some birth", name: "some name", rating: 42, surname: "some surname"}
    @update_attrs %{birth: "some updated birth", name: "some updated name", rating: 43, surname: "some updated surname"}
    @invalid_attrs %{birth: nil, name: nil, rating: nil, surname: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authors.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert Authors.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert Authors.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = Authors.create_author(@valid_attrs)
      assert author.birth == "some birth"
      assert author.name == "some name"
      assert author.rating == 42
      assert author.surname == "some surname"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authors.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, author} = Authors.update_author(author, @update_attrs)
      assert %Author{} = author
      assert author.birth == "some updated birth"
      assert author.name == "some updated name"
      assert author.rating == 43
      assert author.surname == "some updated surname"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = Authors.update_author(author, @invalid_attrs)
      assert author == Authors.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = Authors.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Authors.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = Authors.change_author(author)
    end
  end
end
