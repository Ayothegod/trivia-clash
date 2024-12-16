defmodule Trivia.Arenas.ArenaPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "arena_players" do
    belongs_to :arena, Trivia.Arenas.Arena
    belongs_to :user, Trivia.Accounts.User
    field :is_player, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(arena_player, attrs) do
    arena_player
    |> cast(attrs, [:arena_id, :user_id, :is_player])
    |> validate_required([:arena_id, :user_id, :is_player])
    |> assoc_constraint(:arena)
    |> assoc_constraint(:user)
  end
end
