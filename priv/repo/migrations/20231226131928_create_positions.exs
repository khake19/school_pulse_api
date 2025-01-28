defmodule SchoolPulseApi.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
      add :salary_grade, :string

      timestamps()
    end
  end
end
