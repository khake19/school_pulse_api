defmodule SchoolPulseApi.Repo.Migrations.TeacherAddPositionIdColumn do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :position_id, references(:positions, column: :id, type: :serial)
    end
  end
end
