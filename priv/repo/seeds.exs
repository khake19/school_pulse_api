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
# alias SchoolPulseApi.Accounts
# alias SchoolPulseApi.Accounts.User
# alias SchoolPulseApi.Schools
# alias SchoolPulseApi.Schools.School
# alias SchoolPulseApi.Teachers.Teacher
alias SchoolPulseApi.Teachers.Position

# Repo.insert!(%User{first_name: "kerk", email: "kerk.jazul@gmail.com"})
# Repo.insert!(%User{first_name: "hazel", email: "hazel.jazul@gmail.com"})
# Repo.insert!(%User{first_name: "mario", email: "mario@gmail.com"})
# Repo.insert!(%User{first_name: "luigi", email: "luigi@gmail.com"})
# Repo.insert!(%User{first_name: "watsy", email: "watsy@gmail.com"})

schools = [
  "Aroroy East Central School",
  "Balawing Elementary School" ,
  "Balete Elementary School",
  "Bienvinido R. Bulalacao Memorial Elementary School",
  "Cabangcalan Elementary School",
  "Capsay Elementary School",
  "Concepcion Elementary School",
  "Lanang Elementary School",
  "Luy-a Elementary School" ,
  "Malubi Elementary School",
  "Managanaga Elementary School"
]

# users = Accounts.list_users()
# school = Schools.get_school!("03e221fb-f781-4488-af24-74661dc92fb8")

# Enum.map(schools, &(Repo.insert!(%School{name: &1})))
# Enum.map(users, &(Repo.insert!(%Teacher{position: "teacher 1", user: &1, school: school})))

positions = [
  %{
    name: 'Teacher I',
    salary_grade: 'SG11',
    type: 'teaching'
  },
  %{
    name: 'Teacher II',
    salary_grade: 'SG12',
    type: 'teaching'
  },
  %{
    name: 'Teacher III',
    salary_grade: 'SG13',
    type: 'teaching'
  },
  %{
    name: 'Master Teacher I',
    salary_grade: 'SG18',
    type: 'teaching'
  },
  %{
    name: 'Master Teacher II',
    salary_grade: 'SG19',
    type: 'teaching'
  },
  %{
    name: 'Master Teacher III',
    salary_grade: 'SG20',
    type: 'teaching'
  },
  %{
    name: 'Head teacher I',
    salary_grade: 'SG14',
    type: 'administrative'
  },
  %{
    name: 'Head teacher II',
    salary_grade: 'SG15',
    type: 'administrative'
  },
  %{
    name: 'Head teacher III',
    salary_grade: 'SG16',
    type: 'administrative'
  },
  %{
    name: 'Principal I',
    salary_grade: 'SG19',
    type: 'administrative'
  },
  %{
    name: 'Principal II',
    salary_grade: 'SG20',
    type: 'administrative'
  },
  %{
    name: 'Principal III',
    salary_grade: 'SG21',
    type: 'administrative'
  },
  %{
    name: 'Principal IV',
    salary_grade: 'SG22',
    type: 'administrative'
  },
  %{
    name: 'District supervisor',
    salary_grade: 'SG22',
    type: 'administrative'
  },
  %{
    name: 'Education supervisor I',
    salary_grade: 'SG22',
    type: 'administrative',
  },
  %{
    name: 'Schools division superintendent I',
    salary_grade: 'SG26',
    type: 'executive',
  },
]



Enum.map(positions, fn position ->(Repo.insert!(%Position{
  name: List.to_string(position.name),
  salary_grade: List.to_string(position.salary_grade),
  type: List.to_string(position.type)
  })) end
)
