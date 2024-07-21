defmodule SchoolPulseApi.Accounts.DocumentType do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Accounts

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "document_types" do
    field :name, :string
    field :serial_id, :integer
    has_many :documents, Accounts.Document
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :integer])
    |> validate_required([:name, :integer])
  end
end
