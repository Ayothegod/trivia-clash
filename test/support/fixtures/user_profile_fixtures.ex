defmodule Trivia.UserProfileFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Trivia.UserProfile` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        arenas_joined: %{},
        followers: [1, 2],
        followings: [1, 2],
        games_played: %{},
        past_achievements: %{},
        past_summaries: %{},
        summary_is_public: true
      })
      |> Trivia.UserProfile.create_profile()

    profile
  end
end
