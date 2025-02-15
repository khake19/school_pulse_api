defmodule SchoolPulseApi.Accounts.User do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset

  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Teachers
  alias SchoolPulseApi.Schools

  @derive {
    Flop.Schema,
    filterable: [:full_name, :email],
    sortable: [:full_name, :email],
    adapter_opts: [
      compound_fields: [full_name: [:first_name, :middle_name, :last_name, :suffix]]
    ]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :suffix, :string
    field :email, :string
    field :username, :string
    field :password, :string
    field :gender, :string
    field :avatar, SchoolPulseApi.Avatar.Type

    belongs_to :role, Accounts.Role, type: :id

    has_one :teacher, Teachers.Teacher, foreign_key: :user_id
    has_many :documents, Accounts.Document, foreign_key: :user_id
    many_to_many :schools, Schools.School, join_through: "school_admins", on_replace: :delete

    timestamps()
  end

  @spec changeset(
          {map(), map()}
          | %{
              :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :role_id])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> cast_assoc(:role_id)
    |> put_password_hash()
  end

  def avatar_changeset(user, attrs) do
    user
    |> cast_attachments(attrs, [:avatar])
    |> validate_required([:avatar])
  end

  def account_no_password_changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :middle_name, :suffix, :last_name, :email, :gender])
    |> validate_required([:email, :first_name, :middle_name])
    |> unique_constraint(:email)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
