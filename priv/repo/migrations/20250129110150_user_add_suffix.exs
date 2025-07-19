defmodule SchoolPulseApi.Repo.Migrations.UserAddSuffix do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :suffix, :string
    end

    alter table(:teachers) do
      remove :remarks
      add :date_promotion, :date
    end
  end
end
