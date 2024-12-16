defmodule Trivia.ArenaPlayers.ArenaPlayer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "arena_players" do
    belongs_to :arena, Trivia.Arenas.Arena
    # belongs_to :player, Trivia.Players.Player
    field :is_player, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(arena_player, attrs) do
    arena_player
    |> cast(attrs, [:is_player, :arena_id])
    |> validate_required([:is_player, :arena_id])
  end
end
