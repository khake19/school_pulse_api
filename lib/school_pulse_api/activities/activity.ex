defmodule SchoolPulseApi.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activities" do
    field :description, :string
    field :metadata, :map
    field :activity_type, Ecto.Enum, values: [:created, :updated, :deleted, :status_changed]
    field :entity_type, Ecto.Enum, values: [:school, :user, :teacher, :document, :leave]
    field :entity_id, Ecto.UUID
    field :ip_address, :string
    field :user_agent, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [
      :activity_type,
      :entity_type,
      :entity_id,
      :description,
      :metadata,
      :ip_address,
      :user_agent
    ])
    |> validate_required([
      :activity_type,
      :entity_type,
      :entity_id,
      :description,
      :metadata,
      :ip_address,
      :user_agent
    ])
  end
end
