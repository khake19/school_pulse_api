defmodule SchoolPulseApi.Templates.Template do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  schema "templates" do
    field :name, :string
    field :description, :string
    field :template_data, :map  # JSONB data for template
    timestamps()
  end

  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name, :description, :template_data])
    |> validate_required([:name, :template_data])
  end
end
