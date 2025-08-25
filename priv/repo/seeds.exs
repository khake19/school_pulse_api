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

admin_role =
  Repo.insert!(%SchoolPulseApi.Accounts.Role{
    name: "admin"
  })

teacher_role =
  Repo.insert!(%SchoolPulseApi.Accounts.Role{
    name: "school admin",
    inserted_at: now,
    updated_at: now
  })

# Now use the UUID for the user
teacher =
  Repo.insert!(%User{
    first_name: "hazel",
    last_name: "jazul",
    email: "hazel@schoolpulse.com",
    # Use the UUID, not an integer
    role_id: admin_role.id,
    password: Argon2.hash_pwd_salt("password123")
  })

Repo.insert!(%User{
  first_name: "kerk",
  last_name: "jazul",
  email: "kerk@schoolpulse.com"
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
  "Managanaga Elementary School",
  "San Isidro Elementary School",
  "Santa Cruz Elementary School",
  "San Jose Elementary School",
  "San Antonio Elementary School",
  "San Miguel Elementary School",
  "San Pedro Elementary School",
  "San Vicente Elementary School",
  "San Lorenzo Elementary School",
  "San Rafael Elementary School",
  "San Gabriel Elementary School",
  "San Fernando Elementary School",
  "San Carlos Elementary School",
  "San Nicolas Elementary School",
  "San Agustin Elementary School",
  "San Sebastian Elementary School",
  "San Roque Elementary School",
  "San Pablo Elementary School",
  "San Mateo Elementary School",
  "San Juan Elementary School",
  "San Francisco Elementary School",
  "San Diego Elementary School",
  "San Luis Elementary School",
  "San Marcos Elementary School",
  "San Andres Elementary School",
  "San Bartolome Elementary School",
  "San Cristobal Elementary School",
  "San Esteban Elementary School",
  "San Felipe Elementary School",
  "San Geronimo Elementary School",
  "San Hilario Elementary School"
]

# Enum.map(schools, &Repo.insert!(%School{name: &1}))

# Get all existing schools from the database
school_records = Repo.all(School)


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
position_records =
  Enum.map(positions, fn position ->
    Repo.insert!(%Position{
      name: List.to_string(position.name),
      salary_grade: List.to_string(position.salary_grade),
      type: List.to_string(position.type)
    })
  end)

# Generate sample teacher data using unique_names_generator library
# Function to generate random names with the library
generate_random_name = fn ->
  gender = Enum.random([:male, :female])


  first_name = UniqueNamesGenerator.generate([:names])
  last_name = UniqueNamesGenerator.generate([:names])

  {first_name, last_name, gender}
end

# Create 5 teachers for each school
Enum.each(school_records, fn school ->
  Enum.each(1..5, fn teacher_index ->
    # Generate random name and gender
    {first_name, last_name, gender} = generate_random_name.()

    # Generate unique email and employee number
    email = "#{String.downcase(first_name)}#{teacher_index}@#{String.replace(school.name, " ", "") |> String.downcase()}.edu.ph"
    employee_number = "T#{String.pad_leading("#{teacher_index}", 3, "0")}#{String.slice(school.name, 0, 3)}"

    # Create user
    user = Repo.insert!(%User{
      first_name: first_name,
      last_name: last_name,
      email: email,
      password: Argon2.hash_pwd_salt("password123"),
      gender: Atom.to_string(gender)
    })

    # Create teacher
    Repo.insert!(%Teacher{
      user_id: user.id,
      position_id: Enum.random(position_records).id,
      school_id: school.id,
      employee_number: employee_number,
      philhealth: "PH#{:rand.uniform(999999999)}",
      gsis: "GSIS#{:rand.uniform(999999999)}",
      pagibig: "PAGIBIG#{:rand.uniform(999999999)}",
      tin: "TIN#{:rand.uniform(999999999)}",
      plantilla: "PL#{:rand.uniform(999999)}",
      date_hired: Date.add(Date.utc_today(), -:rand.uniform(365 * 10)),
      date_promotion: Date.add(Date.utc_today(), -:rand.uniform(365 * 5))
    })
  end)
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
