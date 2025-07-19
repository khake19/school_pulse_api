defmodule SchoolPulseApi.Teachers.Teacher do
  use Ecto.Schema
  import Ecto.Changeset
  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Schools
  alias SchoolPulseApi.Teachers

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:employee_number, :email],
    adapter_opts: [
      join_fields: [
        email: [
          binding: :users,
          field: :email,
          ecto_type: :string
        ],
        first_name: [
          binding: :users,
          field: :first_name,
          ecto_type: :string
        ],
        middle_name: [
          binding: :users,
          field: :middle_name,
          ecto_type: :string
        ],
        last_name: [
          binding: :users,
          field: :last_name,
          ecto_type: :string
        ],
        suffix: [
          binding: :users,
          field: :suffix,
          ecto_type: :string
        ]
      ],
      compound_fields: [
        search: [:employee_number, :email, :first_name, :middle_name, :last_name, :suffix]
      ]
    ]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teachers" do
    field :employee_number, :string
    field :philhealth, :string
    field :gsis, :string
    field :pagibig, :string
    field :tin, :string
    field :plantilla, :string
    field :date_hired, :date
    field :date_promotion, :date
    belongs_to :position, Teachers.Position, type: :binary_id
    belongs_to :user, Accounts.User
    belongs_to :school, Schools.School
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :employee_number,
      :position_id,
      :user_id,
      :school_id,
      :philhealth,
      :gsis,
      :pagibig,
      :tin,
      :plantilla,
      :date_hired,
      :date_promotion
    ])
  end
end
