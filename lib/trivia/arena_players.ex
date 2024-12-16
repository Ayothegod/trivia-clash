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

  # def update_arena(%Arena{} = arena, attrs) do
  #   arena
  #   |> Arena.changeset(attrs)
  #   |> Repo.update()
  # end

  # def delete_arena(%Arena{} = arena) do
  #   Repo.delete(arena)
  # end

  # def change_arena(%Arena{} = arena, attrs \\ %{}) do
  #   Arena.changeset(arena, attrs)
  # end
end
