defmodule SchoolPulseApi.Repo.Migrations.DocumentAddDatePeriod do
  use Ecto.Migration

  def change do
    alter table(:documents) do
      add :date_period, :text
    end
  end
end
