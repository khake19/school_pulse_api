defmodule SchoolPulseApi.Teachers.Teacher do
  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Schools
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teachers" do
    field :position, :string

    belongs_to :user, Accounts.User
    belongs_to :school, Schools.School 
    timestamps()
  end

  @doc false
  def changeset(teacher, attrs) do
    teacher
    |> cast(attrs, [:position])
    |> validate_required([:position])
  end
end
