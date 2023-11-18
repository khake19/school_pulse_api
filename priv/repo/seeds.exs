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
alias SchoolPulseApi.Accounts.User
alias SchoolPulseApi.Schools.School

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

Enum.map(schools, &(Repo.insert!(%School{name: &1})))
