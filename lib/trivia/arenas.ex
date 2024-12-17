defmodule Trivia.Arenas do
  import Ecto.Query, warn: false
  alias Trivia.Repo

  alias Trivia.Arenas.Arena

  # def list_arenas do
  #   Repo.all(Arena)
  # end

  # query =
  #   from u in User,
  #     preload: [:user_profile],
  #     where: u.id == ^id,
  #     select: %{user: u}

  # def test do
  #   query =
  #     from p in Profile,
  #       join: u in User,
  #       on: p.user_id == u.id,
  #       where: p.id == ^id,
  #       select: %{profile: p, user: u}
  # end

  def list_active_arenas do
    query =
      from a in Arena,
        where: a.is_ended == false

    # select: %{arena: a}
    Repo.all(query)
  end

  def get_arena!(id) do
    Repo.get!(Arena, id)
  end

  def get_arena_with_theme_players!(id) do
    Repo.get!(Trivia.Arenas.Arena, id)
    |> Repo.preload([:arena_players, :arena_theme])
  end

  def get_arena_with_players!(id) do
    Repo.get!(Trivia.Arenas.Arena, id)
    |> Repo.preload([:arena_players])
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
