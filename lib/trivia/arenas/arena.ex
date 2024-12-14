defmodule Trivia.Arenas.Arena do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "arenas" do
    field :public, :boolean, default: false
    field :players, {:array, :map}, default: []
    field :no_of_players, :integer, default: 2
    field :observer_capacity, :integer, default: 6

    belongs_to :arena_theme, Trivia.ArenaThemeContext.ArenaTheme, foreign_key: :theme_id

    timestamps(type: :utc_datetime)
  end

  def changeset(arena, attrs) do
    arena
    |> cast(attrs, [:no_of_players, :observer_capacity, :public, :players, :theme_id])
    |> validate_required([:public, :no_of_players, :observer_capacity])
    |> validate_inclusion(:no_of_players, 2..6,
      message: "Number of players must be between 2 and 6."
    )
    |> validate_number(:observer_capacity,
      greater_than_or_equal_to: 0,
      message: "Observer capacity must be non-negative."
    )
    |> validate_players
  end

  defp validate_players(changeset) do
    case get_field(changeset, :players) do
      [] ->
        add_error(changeset, :players, "Players list must contain at least one player.")

      players when is_list(players) ->
        if Enum.any?(players, &is_map/1) do
          changeset
        else
          add_error(changeset, :players, "Players list must contain at least one map.")
        end

      _ ->
        add_error(changeset, :players, "Players list must be an array.")
    end
  end
end

# NOTE: arena structure
#  public            | boolean    | not null |
#  no_of_players     | integer                        |
#  observer_capacity | integer                        |
#  theme_id          | uuid
#  players           | jsonb[]
# %{
#   "no_of_players" => "2",
#   "observer_capacity" => "6",
#   "player" => %{id: 18, is_player: true},
#   "public" => "false",
#   "theme_id" => "b8dc7896-8b5a-4313-8e1a-894611e74b14"
# }
