defmodule SchoolPulseApi.Repo.Migrations.PositionsAddTypeColumn do
  use Ecto.Migration

  def change do
    alter table(:positions) do
      add :type, :text
    end
  end
end
