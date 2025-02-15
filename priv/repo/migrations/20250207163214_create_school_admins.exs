defmodule SchoolPulseApi.Repo.Migrations.CreateSchoolAdmins do
  use Ecto.Migration

  def change do
    create table(:school_admins, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      add :school_id, references(:schools, on_delete: :delete_all, type: :binary_id),
        primary_key: true

      timestamps()
    end

    create index(:school_admins, [:user_id])
    create index(:school_admins, [:school_id])
  end
end
