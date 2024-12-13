defmodule Trivia.ArenaThemeContext.ArenaTheme do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "arena_themes" do
    field :name, :string
    field :status, :boolean, default: false
    field :description, :string
    field :color_scheme, :map
    belongs_to :arena, Trivia.Arenas.Arena

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(arena_theme, attrs) do
    arena_theme
    |> cast(attrs, [:name, :description, :color_scheme, :status])
    |> validate_required([:name, :description, :status])
  end
end
