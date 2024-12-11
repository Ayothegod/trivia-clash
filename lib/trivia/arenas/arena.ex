defmodule Trivia.Arenas.Arena do
  use Ecto.Schema
  import Ecto.Changeset

  schema "arenas" do
    field :public, :boolean, default: false
    field :is_player, :boolean, default: false
    field :players, {:array, :string}, default: []
    field :arena_theme, :map, default: %{}
    field :no_of_players, :integer, default: 2
    field :observer_capacity, :integer, default: 6

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(arena, attrs) do
    arena
    |> cast(attrs, [:no_of_players, :observer_capacity])
    |> validate_required([:is_player, :players, :public, :no_of_players, :observer_capacity])
    |> validate_inclusion(:no_of_players, 2..6,
      message: "Number of players must be between 2 and 6."
    )
  end
end


#   |> validate_inclusion(:no_of_players, 1..100, message: "Number of players must be between 1 and 100.")
#   |> validate_number(:observer_capacity, greater_than_or_equal_to: 0, message: "Observer capacity must be non-negative.")

# default_map: %{background_color: "#FFFFFF", font: "Roboto", sound_effects: "classic"}


