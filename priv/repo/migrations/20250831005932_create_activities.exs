defmodule SchoolPulseApi.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :activity_type, :string
      add :entity_type, :string
      add :entity_id, :uuid
      add :description, :text
      add :metadata, :map
      add :ip_address, :string
      add :user_agent, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:activities, [:user_id])
  end
end
