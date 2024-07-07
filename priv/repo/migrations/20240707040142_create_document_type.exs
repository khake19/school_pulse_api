defmodule SchoolPulseApi.Repo.Migrations.CreateDocumentType do
  use Ecto.Migration

  def change do
    create table(:document_types, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
    end
  end
end
