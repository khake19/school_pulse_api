defmodule SchoolPulseApi.Schools.SchoolAdmin do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  @primary_key false
  schema "school_admins" do
    field :user_id, :binary_id, primary_key: true
    field :school_id, :binary_id, primary_key: true
    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
