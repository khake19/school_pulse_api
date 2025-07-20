defmodule SchoolPulseApi.Teachers.Position do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Teachers

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "positions" do
    field :name, :string
    field :salary_grade, :string
    field :type, :string
    has_many :teachers, Teachers.Teacher

    timestamps()
  end

  def changeset(position, attrs) do
    position
    |> cast(attrs, [:name, :salary_grade, :type])
    |> validate_required([:name, :salary_grade, :type])
  end
end
