defmodule Trivia.ArenasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trivia.Arenas` context.
  """

  @doc """
  Generate a arena.
  """
  def arena_fixture(attrs \\ %{}) do
    {:ok, arena} =
      attrs
      |> Enum.into(%{
        arena_theme: %{},
        is_player: true,
        no_of_players: 42,
        observer_capacity: 42,
        players: ["option1", "option2"],
        public: true
      })
      |> Trivia.Arenas.create_arena()

    arena
  end
end
