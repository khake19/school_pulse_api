defmodule SchoolPulseApi.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "roles" do
    field :name, :string
    field :description, :string
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
