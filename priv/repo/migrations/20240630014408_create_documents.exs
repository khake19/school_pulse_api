defmodule SchoolPulseApi.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :integer
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :file, :string

      timestamps()
    end

    create index(:documents, [:user_id])
  end
end
