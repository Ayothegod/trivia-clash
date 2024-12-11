defmodule Trivia.Repo.Migrations.CreateUserProfile do
  use Ecto.Migration

  def change do
    create table(:user_profile) do
      add :arenas_joined, :map
      add :games_played, :map
      add :followers, {:array, :integer}
      add :followings, {:array, :integer}
      add :past_achievements, :map
      add :past_summaries, :map
      add :summary_is_public, :boolean, default: false, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:user_profiles, [:user_id])
    create unique_index(:user_profiles, [:user_id])
  end
end
