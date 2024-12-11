defmodule Trivia.Repo.Migrations.CreateArenas do
  use Ecto.Migration

  def change do
    create table(:arenas) do
      add :is_player, :boolean, default: false, null: false
      add :players, {:array, :string}
      add :public, :boolean, default: false, null: false
      add :arena_theme, :map
      add :no_of_players, :integer
      add :observer_capacity, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
