# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SchoolPulseApi.Repo.insert!(%SchoolPulseApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SchoolPulseApi.Repo
alias SchoolPulseApi.Accounts
alias SchoolPulseApi.Accounts.User
alias SchoolPulseApi.Accounts.DocumentType
alias SchoolPulseApi.Schools
alias SchoolPulseApi.Schools.School
alias SchoolPulseApi.Teachers.Teacher
alias SchoolPulseApi.Teachers.Position


# Seed roles first using Ecto struct so timestamps are set
now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

admin_role = Repo.insert!(%SchoolPulseApi.Accounts.Role{
  name: "admin"
})
teacher_role = Repo.insert!(%SchoolPulseApi.Accounts.Role{
  name: "school admin",
  inserted_at: now,
  updated_at: now
})

# Now use the UUID for the user
teacher = Repo.insert!(%User{
  first_name: "hazel",
  last_name: "jazul",
  email: "hazel@schoolpulse.com",
  role_id: admin_role.id,  # Use the UUID, not an integer
  password: Argon2.hash_pwd_salt("password123")
})

Repo.insert!(%User{
  first_name: "kerk",
  last_name: "jazul",
  email: "kerk@schoolpulse.com",
})

schools = [
  "Aroroy East Central School",
  "Balawing Elementary School",
  "Balete Elementary School",
  "Bienvinido R. Bulalacao Memorial Elementary School",
  "Cabangcalan Elementary School",
  "Capsay Elementary School",
  "Concepcion Elementary School",
  "Lanang Elementary School",
  "Luy-a Elementary School",
  "Malubi Elementary School",
  "Managanaga Elementary School"
]

# Insert schools and collect their records
school_records = Enum.map(schools, &Repo.insert!(%School{name: &1}))

positions = [
  %{
    name: ~c"Teacher I",
    salary_grade: ~c"SG11",
    type: ~c"teaching"
  },
  %{
    name: ~c"Teacher II",
    salary_grade: ~c"SG12",
    type: ~c"teaching"
  },
  %{
    name: ~c"Teacher III",
    salary_grade: ~c"SG13",
    type: ~c"teaching"
  },
  %{
    name: ~c"Master Teacher I",
    salary_grade: ~c"SG18",
    type: ~c"teaching"
  },
  %{
    name: ~c"Master Teacher II",
    salary_grade: ~c"SG19",
    type: ~c"teaching"
  },
  %{
    name: ~c"Master Teacher III",
    salary_grade: ~c"SG20",
    type: ~c"teaching"
  },
  %{
    name: ~c"Head teacher I",
    salary_grade: ~c"SG14",
    type: ~c"administrative"
  },
  %{
    name: ~c"Head teacher II",
    salary_grade: ~c"SG15",
    type: ~c"administrative"
  },
  %{
    name: ~c"Head teacher III",
    salary_grade: ~c"SG16",
    type: ~c"administrative"
  },
  %{
    name: ~c"Principal I",
    salary_grade: ~c"SG19",
    type: ~c"administrative"
  },
  %{
    name: ~c"Principal II",
    salary_grade: ~c"SG20",
    type: ~c"administrative"
  },
  %{
    name: ~c"Principal III",
    salary_grade: ~c"SG21",
    type: ~c"administrative"
  },
  %{
    name: ~c"Principal IV",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Public schools district supervisor",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Administrative aide I",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Administrative aide I",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Administrative assistant I",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Administrative assistant II",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Administrative assistant III",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Administrative officer II",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  },
  %{
    name: ~c"Planning developmental officer III",
    salary_grade: ~c"SG22",
    type: ~c"administrative"
  }
]

# Insert positions and collect their records
position_records = Enum.map(positions, fn position ->
  Repo.insert!(%Position{
    name: List.to_string(position.name),
    salary_grade: List.to_string(position.salary_grade),
    type: List.to_string(position.type)
  })
end)

document_types = [
  %{
    name: ~c"Daily Time Record"
  }
]

Repo.insert!(%Teacher{
  user_id: teacher.id,
  position_id: position_records |> List.first() |> Map.get(:id),
  school_id: school_records |> List.first() |> Map.get(:id)
})

Enum.map(document_types, fn document_type ->
  Repo.insert!(%DocumentType{
    name: List.to_string(document_type.name)
  })
end)
