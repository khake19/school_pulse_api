defmodule GlobalSetup do
  def run do
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
    alias SchoolPulseApi.Accounts.User
    alias SchoolPulseApi.Accounts.DocumentType
    # alias SchoolPulseApi.Schools
    alias SchoolPulseApi.Schools.School
    # alias SchoolPulseApi.Teachers.Teacher
    alias SchoolPulseApi.Teachers.Position

    Repo.insert!(%User{
      first_name: "admin",
      email: "admin@schoolpulse.com",
      password: Argon2.hash_pwd_salt("password123")
    })

    schools = [
      "Aroroy National High School",
      "Aroroy Stand Alone Senior High School",
      "Aroroy East Central School",
      "Balawing Elementary School",
      "Balete Elementary School",
      "Balete High School",
      "Bienvinido R. Bulalacao Memorial Elementary School",
      "Cabangcalan Elementary School",
      "Cabangcalan High School",
      "Capsay Elementary School",
      "Concepcion Elementary School",
      "Elisa E. Corpus Elementary School",
      "Jaboyoan Elementary School",
      "Lanang Elementary School",
      "Luy-a National High School",
      "Luy-a Elementary School",
      "Malubi Elementary School",
      "Managanaga Elementary School",
      "Manamoc Upland Integrated School",
      "Nabongsoran Elementary School",
      "Nabongsoran High School",
      "Pangle Elementary School",
      "Panique National High School",
      "Pinanaan Elementary School",
      "Syndicate Elementary School",
      "Syndicate National School",
      "Tinago Elementary School",
    ]

    Enum.map(schools, &Repo.insert!(%School{name: &1}))

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

    Enum.map(positions, fn position ->
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

    Enum.map(document_types, fn document_type ->
      Repo.insert!(%DocumentType{
        name: List.to_string(document_type.name)
      })
    end)
  end
end
