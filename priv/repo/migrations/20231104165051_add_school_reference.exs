defmodule SchoolPulseApi.Repo.Migrations.AddSchoolReference do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :school_id, references(:schools, column: :id, type: :uuid)
    end
  end
end
