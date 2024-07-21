defmodule SchoolPulseApi.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:document_types, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :serial_id, :integer
      add :name, :string
    end

    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :document_type_id, references(:document_types, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :path, :string
      add :size, :integer
      add :content_type, :string

      timestamps()
    end

    create index(:documents, [:user_id])
  end
end
