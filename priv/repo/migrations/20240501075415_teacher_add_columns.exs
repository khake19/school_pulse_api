defmodule SchoolPulseApi.Repo.Migrations.TeacherAddColumns do
  use Ecto.Migration

  def change do
    alter table(:teachers) do
      add :employee_number, :integer
      add :remarks, :string
    end

    alter table(:users) do
      add :gender, :string
    end
  end
end
