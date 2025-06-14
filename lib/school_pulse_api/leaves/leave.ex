defmodule SchoolPulseApi.Leaves.Leave do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Teachers.Teacher

  @derive {
    Flop.Schema,
    filterable: [:type, :start_at, :end_at, :remarks],
    sortable: [:type, :start_at, :end_at, :remarks]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "leaves" do
    field :type, :string
    field :remarks, :string
    field :start_at, :utc_datetime
    field :end_at, :utc_datetime
    belongs_to :teacher, Teacher

    timestamps()
  end

  @doc false
  def changeset(leave, attrs) do
    leave
    |> cast(attrs, [:remarks, :type, :teacher_id, :start_at, :end_at])
    |> validate_required([:remarks, :type, :teacher_id, :start_at, :end_at])
  end
end
