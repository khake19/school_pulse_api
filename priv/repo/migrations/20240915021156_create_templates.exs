defmodule SchoolPulseApi.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
      add :description, :text
      add :template_data, :jsonb

      timestamps()
    end
  end
end
