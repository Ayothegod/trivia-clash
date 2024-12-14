defmodule Trivia.ArenaThemeContext do
  import Ecto.Query, warn: false
  alias Trivia.Repo

  alias Trivia.ArenaThemeContext.ArenaTheme

  def list_arena_themes do
    Repo.all(ArenaTheme)
  end

  def get_theme_for_select do
    from(t in ArenaTheme,
      select: %{id: t.id, name: t.name}
    )
    |> Repo.all()
  end

  #   from(t in Trivia.ArenaThemeContext.ArenaTheme,
  #   where: t.status == true,
  #   select: %{id: t.id, name: t.name}
  # )
  # |> Repo.all()

  def get_arena_theme!(id), do: Repo.get!(ArenaTheme, id)

  def create_arena_theme(attrs \\ %{}) do
    %ArenaTheme{}
    |> ArenaTheme.changeset(attrs)
    |> Repo.insert()
  end

  def update_arena_theme(%ArenaTheme{} = arena_theme, attrs) do
    arena_theme
    |> ArenaTheme.changeset(attrs)
    |> Repo.update()
  end

  def delete_arena_theme(%ArenaTheme{} = arena_theme) do
    Repo.delete(arena_theme)
  end

  def change_arena_theme(%ArenaTheme{} = arena_theme, attrs \\ %{}) do
    ArenaTheme.changeset(arena_theme, attrs)
  end
end
