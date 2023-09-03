defmodule SchoolPulseApi.Repo.Migrations.AccountsAddUsernamePassword do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :text
      add :password, :text
    end
  end
end
