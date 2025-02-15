defmodule SchoolPulseApi.Schools.School do
  use Ecto.Schema
  import Ecto.Changeset

  alias SchoolPulseApi.Teachers
  alias SchoolPulseApi.Accounts

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "schools" do
    field :name, :string

    has_many :teachers, Teachers.Teacher, foreign_key: :school_id
    many_to_many :users, Accounts.User, join_through: "school_admins", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
