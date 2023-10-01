defmodule SchoolPulseApi.Repo.Migrations.AddUserTeacherReference do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :user_id, references(:users,  column: :id, type: :uuid)
    end
  end
end
