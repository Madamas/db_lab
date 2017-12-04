defmodule Lab2.MangasTest do
  use Lab2.DataCase

  alias Lab2.Mangas

  describe "mangas" do
    alias Lab2.Mangas.Manga

    @valid_attrs %{author_id: 42, genre_id: 42, publisher_id: 42, score: 42}
    @update_attrs %{author_id: 43, genre_id: 43, publisher_id: 43, score: 43}
    @invalid_attrs %{author_id: nil, genre_id: nil, publisher_id: nil, score: nil}

    def manga_fixture(attrs \\ %{}) do
      {:ok, manga} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mangas.create_manga()

      manga
    end

    test "list_mangas/0 returns all mangas" do
      manga = manga_fixture()
      assert Mangas.list_mangas() == [manga]
    end

    test "get_manga!/1 returns the manga with given id" do
      manga = manga_fixture()
      assert Mangas.get_manga!(manga.id) == manga
    end

    test "create_manga/1 with valid data creates a manga" do
      assert {:ok, %Manga{} = manga} = Mangas.create_manga(@valid_attrs)
      assert manga.author_id == 42
      assert manga.genre_id == 42
      assert manga.publisher_id == 42
      assert manga.score == 42
    end

    test "create_manga/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mangas.create_manga(@invalid_attrs)
    end

    test "update_manga/2 with valid data updates the manga" do
      manga = manga_fixture()
      assert {:ok, manga} = Mangas.update_manga(manga, @update_attrs)
      assert %Manga{} = manga
      assert manga.author_id == 43
      assert manga.genre_id == 43
      assert manga.publisher_id == 43
      assert manga.score == 43
    end

    test "update_manga/2 with invalid data returns error changeset" do
      manga = manga_fixture()
      assert {:error, %Ecto.Changeset{}} = Mangas.update_manga(manga, @invalid_attrs)
      assert manga == Mangas.get_manga!(manga.id)
    end

    test "delete_manga/1 deletes the manga" do
      manga = manga_fixture()
      assert {:ok, %Manga{}} = Mangas.delete_manga(manga)
      assert_raise Ecto.NoResultsError, fn -> Mangas.get_manga!(manga.id) end
    end

    test "change_manga/1 returns a manga changeset" do
      manga = manga_fixture()
      assert %Ecto.Changeset{} = Mangas.change_manga(manga)
    end
  end
end
