defmodule SchoolPulseApi.Accounts.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Accounts
  use Waffle.Ecto.Schema

  @derive {
    Flop.Schema,
    filterable: [:path], sortable: [:path]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :path, SchoolPulseApi.FileUploader.Type
    field :size, :integer
    field :content_type, :string
    belongs_to :user, Accounts.User
    belongs_to :document_type, Accounts.DocumentType

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
    |> cast(attrs, [:user_id, :document_type_id, :size, :content_type])
    |> validate_required([:user_id, :document_type_id])
  end

  def file_changeset(document, attrs) do
    document
    |> cast_attachments(attrs, [:path])
    |> validate_required([:path])
  end
end
