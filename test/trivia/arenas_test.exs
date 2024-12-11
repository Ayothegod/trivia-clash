defmodule Trivia.ArenasTest do
  use Trivia.DataCase

  alias Trivia.Arenas

  describe "arenas" do
    alias Trivia.Arenas.Arena

    import Trivia.ArenasFixtures

    @invalid_attrs %{public: nil, is_player: nil, players: nil, arena_theme: nil, no_of_players: nil, observer_capacity: nil}

    test "list_arenas/0 returns all arenas" do
      arena = arena_fixture()
      assert Arenas.list_arenas() == [arena]
    end

    test "get_arena!/1 returns the arena with given id" do
      arena = arena_fixture()
      assert Arenas.get_arena!(arena.id) == arena
    end

    test "create_arena/1 with valid data creates a arena" do
      valid_attrs = %{public: true, is_player: true, players: ["option1", "option2"], arena_theme: %{}, no_of_players: 42, observer_capacity: 42}

      assert {:ok, %Arena{} = arena} = Arenas.create_arena(valid_attrs)
      assert arena.public == true
      assert arena.is_player == true
      assert arena.players == ["option1", "option2"]
      assert arena.arena_theme == %{}
      assert arena.no_of_players == 42
      assert arena.observer_capacity == 42
    end

    test "create_arena/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Arenas.create_arena(@invalid_attrs)
    end

    test "update_arena/2 with valid data updates the arena" do
      arena = arena_fixture()
      update_attrs = %{public: false, is_player: false, players: ["option1"], arena_theme: %{}, no_of_players: 43, observer_capacity: 43}

      assert {:ok, %Arena{} = arena} = Arenas.update_arena(arena, update_attrs)
      assert arena.public == false
      assert arena.is_player == false
      assert arena.players == ["option1"]
      assert arena.arena_theme == %{}
      assert arena.no_of_players == 43
      assert arena.observer_capacity == 43
    end

    test "update_arena/2 with invalid data returns error changeset" do
      arena = arena_fixture()
      assert {:error, %Ecto.Changeset{}} = Arenas.update_arena(arena, @invalid_attrs)
      assert arena == Arenas.get_arena!(arena.id)
    end

    test "delete_arena/1 deletes the arena" do
      arena = arena_fixture()
      assert {:ok, %Arena{}} = Arenas.delete_arena(arena)
      assert_raise Ecto.NoResultsError, fn -> Arenas.get_arena!(arena.id) end
    end

    test "change_arena/1 returns a arena changeset" do
      arena = arena_fixture()
      assert %Ecto.Changeset{} = Arenas.change_arena(arena)
    end
  end
end
