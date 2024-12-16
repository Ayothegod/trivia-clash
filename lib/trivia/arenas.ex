defmodule Trivia.Arenas do
  import Ecto.Query, warn: false
  alias Trivia.Repo

  alias Trivia.Arenas.Arena

  def list_arenas do
    Repo.all(Arena)
  end

  # def list_arenas do
  #   Repo.all(Arena)
  # end

  # query =
  #   from u in User,
  #     preload: [:user_profile],
  #     where: u.id == ^id,
  #     select: %{user: u}

  # def get_arena!(id) do
  #   query =
  #     from a in Arena,
  #     preload: [:arena_themes],
  #     where u.id == ^id,
  #     select: u

  #   Repo.get!(query)
  # end

  def get_arena!(id) do
    Repo.get!(Arena, id)
  end

  def create_arena(attrs \\ %{}) do
    %Arena{}
    |> Arena.changeset(attrs)
    |> Repo.insert()
  end

  def update_arena(%Arena{} = arena, attrs) do
    arena
    |> Arena.changeset(attrs)
    |> Repo.update()
  end

  def delete_arena(%Arena{} = arena) do
    Repo.delete(arena)
  end

  def change_arena(%Arena{} = arena, attrs \\ %{}) do
    Arena.changeset(arena, attrs)
  end
end
