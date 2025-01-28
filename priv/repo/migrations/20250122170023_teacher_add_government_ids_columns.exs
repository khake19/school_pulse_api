defmodule SchoolPulseApi.Repo.Migrations.TeacherAddGovernmentIdsColumns do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :date_hired, :date
      add :gsis, :string
      add :pagibig, :string
      add :tin, :string
      add :philhealth, :string
      add :plantilla, :string
      modify :employee_number, :string
    end

    alter table(:users) do
      add :middle_name, :string
    end
  end
end
