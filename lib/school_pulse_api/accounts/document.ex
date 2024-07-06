defmodule SchoolPulseApi.Accounts.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Accounts
  use Waffle.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :type, :integer
    belongs_to :user, Accounts.User
    field :file, SchoolPulseApi.FileUploader.Type
    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:type])
    # |> validate_required([:type])
  end
end
