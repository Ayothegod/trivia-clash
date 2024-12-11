defmodule Trivia.UserProfile.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_profile" do
    field :arenas_joined, {:array, :map}, default: []
    field :games_played, {:array, :map}, default: []
    field :followers, {:array, :integer}, default: []
    field :followings, {:array, :integer}, default: []
    field :past_achievements, {:array, :map}, default: []
    field :past_summaries, {:array, :map}, default: []
    field :summary_is_public, :boolean, default: true

    belongs_to :user, Trivia.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [
      :arenas_joined,
      :games_played,
      :followers,
      :followings,
      :past_achievements,
      :past_summaries,
      :summary_is_public
    ])
    |> validate_required([:followers, :followings, :summary_is_public])
  end
end

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



# def change do
#   alter table(:user_profile) do
#     # Change the existing field to an array of maps. This will depend on the DB you use; for example, PostgreSQL has the `jsonb` type.
#     modify :past_achievements, {:array, :jsonb}, default: []
#     modify :arenas_joined, {:array, :jsonb}, default: []
#     modify :games_played, {:array, :jsonb}, default: []
#     modify :past_summaries, {:array, :jsonb}, default: []
#   end
# end
