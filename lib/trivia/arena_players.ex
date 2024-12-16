defmodule Trivia.Arenas.ArenaPlayers do
  import Ecto.Query, warn: false
  alias Trivia.Repo

  alias Trivia.Arenas.ArenaPlayer

  # def list_arenas do
  #   Repo.all(Arena)
  # end

  # def get_arena!(id) do
  #   Repo.get!(Arena, id)
  # end

  def create_arena_player(attrs \\ %{}) do
    %ArenaPlayer{}
    |> ArenaPlayer.changeset(attrs)
    |> Repo.insert()
  end

  #   has_many :arena_players, Trivia.Arenas.ArenaPlayer
  # has_many :arenas, through: [:arena_players, :arena]

  # you say the user has many arena_players, talking for a single user, are those arena_players also itself in many places?

  def update_arena_players(%ArenaPlayer{} = arena_player, attrs) do
    arena_player
    |> ArenaPlayer.changeset(attrs)
    |> Repo.update()
  end

  # def delete_arena(%Arena{} = arena) do
  #   Repo.delete(arena)
  # end

  # def change_arena(%Arena{} = arena, attrs \\ %{}) do
  #   Arena.changeset(arena, attrs)
  # end
end
