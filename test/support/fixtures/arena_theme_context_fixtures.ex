defmodule Trivia.ArenaThemeContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trivia.ArenaThemeContext` context.
  """

  @doc """
  Generate a arena_theme.
  """
  def arena_theme_fixture(attrs \\ %{}) do
    {:ok, arena_theme} =
      attrs
      |> Enum.into(%{
        color_scheme: %{},
        description: "some description",
        name: "some name",
        status: true
      })
      |> Trivia.ArenaThemeContext.create_arena_theme()

    arena_theme
  end
end
