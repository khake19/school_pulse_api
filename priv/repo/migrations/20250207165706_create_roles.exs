defmodule SchoolPulseApi.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
      add :description, :text

      timestamps()
    end

    alter table(:users) do
      add :role_id, references(:roles, on_delete: :nothing, type: :serial)
    end
  end
end
