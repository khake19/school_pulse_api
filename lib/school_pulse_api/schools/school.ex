defmodule SchoolPulseApi.Schools.School do
  alias SchoolPulseApi.Teachers
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "schools" do
    field :name, :string

    has_many :teachers, Teachers.Teacher, foreign_key: :school_id

    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
