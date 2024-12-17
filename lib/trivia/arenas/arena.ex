defmodule Trivia.Arenas.Arena do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "arenas" do
    field :public, :boolean, default: false
    field :no_of_players, :integer, default: 2
    field :observer_capacity, :integer, default: 6
    field :name, :string
    field :is_ended, :boolean, default: false

    has_many :arena_players, Trivia.Arenas.ArenaPlayer
    belongs_to :arena_theme, Trivia.ArenaThemeContext.ArenaTheme, foreign_key: :theme_id
    # has_many :users, through: [:arena_players, :user]

    timestamps(type: :utc_datetime)
  end

  def changeset(arena, attrs) do
    arena
    |> cast(attrs, [:no_of_players, :observer_capacity, :public, :theme_id, :name, :is_ended])
    |> validate_name()
    |> validate_required([:public, :no_of_players, :observer_capacity])
    |> validate_inclusion(:no_of_players, 2..6,
      message: "Number of players must be between 2 and 6."
    )
    |> validate_number(:observer_capacity,
      greater_than_or_equal_to: 0,
      message: "Observer capacity must be non-negative."
    )
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, max: 72)
  end
end
