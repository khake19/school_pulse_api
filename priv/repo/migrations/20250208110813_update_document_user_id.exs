defmodule SchoolPulseApi.Repo.Migrations.UpdateDocumentUserId do
  use Ecto.Migration

  def change do
    # Drop the existing constraint
    execute "ALTER TABLE documents DROP CONSTRAINT IF EXISTS documents_user_id_fkey"

    alter table(:documents) do
      modify :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
    end
  end
end
