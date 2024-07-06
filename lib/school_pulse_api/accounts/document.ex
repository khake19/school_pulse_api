defmodule SchoolPulseApi.Accounts.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Accounts
  use Waffle.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :type, :integer
    field :file, SchoolPulseApi.FileUploader.Type
    belongs_to :user, Accounts.User
    timestamps()
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:type])
    |> cast_attachments(attrs, [:file])

    # |> validate_required([:type])
  end
end
