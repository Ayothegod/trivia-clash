defmodule Trivia.Repo.Migrations.AddUserIdToProfile do
  use Ecto.Migration

  def change do
    alter table(:user_profile) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create unique_index(:user_profile, [:user_id])

  end
end
