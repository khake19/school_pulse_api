defmodule SchoolPulseApi.Repo.Migrations.CreateLeaves do
  use Ecto.Migration

  def change do
    create table(:leaves, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :remarks, :string
      add :type, :string
      add :teacher_id, references(:teachers, on_delete: :nothing, type: :binary_id)
      add :start_at, :utc_datetime
      add :end_at, :utc_datetime

      timestamps()
    end

    create index(:leaves, [:teacher_id])
  end
end
