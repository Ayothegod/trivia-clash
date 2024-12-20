defmodule Trivia.UserProfile.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  schema "user_profile" do
    field :arenas_joined, {:array, :map}, default: []
    field :games_played, {:array, :map}, default: []
    field :followers, {:array, :integer}, default: []
    field :followings, {:array, :integer}, default: []
    field :past_achievements, {:array, :map}, default: []
    field :past_summaries, {:array, :map}, default: []
    field :summary_is_public, :boolean, default: true
    field :bio, :string, default: ""
    field :profile_picture, :string, default: ""
    field :fullname, :string, default: ""
    field :level, :integer, default: 0

    belongs_to :user, Trivia.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, [
      :user_id,
      :arenas_joined,
      :games_played,
      :followers,
      :followings,
      :past_achievements,
      :past_summaries,
      :summary_is_public,
      :bio,
      :fullname,
      :profile_picture,
      :level
    ])
  end

  def createProfile(profile, attrs) do
    profile
    |> cast(attrs, [
      :user_id,
      :bio,
      :fullname
    ])
    |> validate_fullname()
    |> validate_bio()
  end

  defp validate_fullname(changeset) do
    changeset
    |> validate_required([:fullname], message: "enter your full name.")
    |> validate_length(:fullname, max: 160)
  end

  defp validate_bio(changeset) do
    changeset
    |> validate_required([:bio], message: "enter a short bio...")
    |> validate_length(:bio, min: 6, max: 250)
  end
end

# required

# |> validate_required([:user])
# |> validate_inclusion(:user,
#   message: "User must be provided."
# )

# NOTE: arenas jpined
# [
#   %{id: 1, name: "Trivia Masters", joined_at: ~N[2024-12-10 12:00:00]},
#   %{id: 2, name: "Quiz Lords", joined_at: ~N[2024-12-11 15:30:00]}
# ]

# NOTE: gamees played
# [
#   %{id: 101, arena_id: 1, score: 80, played_at: ~N[2024-12-10 14:00:00]},
#   %{id: 102, arena_id: 2, score: 95, played_at: ~N[2024-12-11 16:00:00]}
# ]

# NOTE: pastr achievement
# [
#   %{type: "Top Scorer", description: "Scored 100+ in 3 games", earned_at: ~N[2024-12-01 18:00:00]}
# ]

# NOTE: pastr summaries
# [
#   %{game_id: 101, summary: "Great performance with 80 points.", created_at: ~N[2024-12-10 15:00:00]}
# ]

# has_many :followers, TriviaApp.User
# has_many :followings, TriviaApp.User
