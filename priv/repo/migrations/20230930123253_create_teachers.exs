defmodule SchoolPulseApi.Repo.Migrations.CreateTeachers do
  use Ecto.Migration

  def change do
    create table(:teachers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :position, :string

      timestamps()
    end
  end
end
