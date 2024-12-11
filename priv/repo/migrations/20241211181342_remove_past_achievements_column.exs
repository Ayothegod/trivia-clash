defmodule Trivia.Repo.Migrations.RemovePastAchievementsColumn do
  use Ecto.Migration

  def change do
    alter table(:user_profile) do
      remove :past_achievements
    end
  end
end
