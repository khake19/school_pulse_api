defmodule SchoolPulseApi.Teachers.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Schools
  alias SchoolPulseApi.Teachers

  use Ecto.Schema
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teachers" do

    belongs_to :position, Teachers.Position
    belongs_to :user, Accounts.User
    belongs_to :school, Schools.School
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:position_id, :user_id, :school_id])
  end
end
