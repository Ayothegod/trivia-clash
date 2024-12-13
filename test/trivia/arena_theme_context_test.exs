defmodule Trivia.ArenaThemeContextTest do
  use Trivia.DataCase

  alias Trivia.ArenaThemeContext

  describe "arena_themes" do
    alias Trivia.ArenaThemeContext.ArenaTheme

    import Trivia.ArenaThemeContextFixtures

    @invalid_attrs %{name: nil, status: nil, description: nil, color_scheme: nil}

    test "list_arena_themes/0 returns all arena_themes" do
      arena_theme = arena_theme_fixture()
      assert ArenaThemeContext.list_arena_themes() == [arena_theme]
    end

    test "get_arena_theme!/1 returns the arena_theme with given id" do
      arena_theme = arena_theme_fixture()
      assert ArenaThemeContext.get_arena_theme!(arena_theme.id) == arena_theme
    end

    test "create_arena_theme/1 with valid data creates a arena_theme" do
      valid_attrs = %{name: "some name", status: true, description: "some description", color_scheme: %{}}

      assert {:ok, %ArenaTheme{} = arena_theme} = ArenaThemeContext.create_arena_theme(valid_attrs)
      assert arena_theme.name == "some name"
      assert arena_theme.status == true
      assert arena_theme.description == "some description"
      assert arena_theme.color_scheme == %{}
    end

    test "create_arena_theme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ArenaThemeContext.create_arena_theme(@invalid_attrs)
    end

    test "update_arena_theme/2 with valid data updates the arena_theme" do
      arena_theme = arena_theme_fixture()
      update_attrs = %{name: "some updated name", status: false, description: "some updated description", color_scheme: %{}}

      assert {:ok, %ArenaTheme{} = arena_theme} = ArenaThemeContext.update_arena_theme(arena_theme, update_attrs)
      assert arena_theme.name == "some updated name"
      assert arena_theme.status == false
      assert arena_theme.description == "some updated description"
      assert arena_theme.color_scheme == %{}
    end

    test "update_arena_theme/2 with invalid data returns error changeset" do
      arena_theme = arena_theme_fixture()
      assert {:error, %Ecto.Changeset{}} = ArenaThemeContext.update_arena_theme(arena_theme, @invalid_attrs)
      assert arena_theme == ArenaThemeContext.get_arena_theme!(arena_theme.id)
    end

    test "delete_arena_theme/1 deletes the arena_theme" do
      arena_theme = arena_theme_fixture()
      assert {:ok, %ArenaTheme{}} = ArenaThemeContext.delete_arena_theme(arena_theme)
      assert_raise Ecto.NoResultsError, fn -> ArenaThemeContext.get_arena_theme!(arena_theme.id) end
    end

    test "change_arena_theme/1 returns a arena_theme changeset" do
      arena_theme = arena_theme_fixture()
      assert %Ecto.Changeset{} = ArenaThemeContext.change_arena_theme(arena_theme)
    end
  end
end
