defmodule SchoolPulseApi.Repo.Migrations.TeacherAddPositionIdColumn do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :position_id, references(:positions, type: :uuid, column: :id)
    end
  end
end
