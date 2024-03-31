defmodule SchoolPulseApiWeb.TeacherController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Repo
  alias SchoolPulseApi.Teachers
  alias SchoolPulseApi.Teachers.Teacher
  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Accounts.User
  alias SchoolPulseApi.Schools


  action_fallback SchoolPulseApiWeb.FallbackController

  def index(conn, %{"school_id" => school_id}) do
    teachers = Teachers.list_teachers(school_id) |> Repo.preload([:user, :school, :position])
    render(conn, :index, teachers: teachers)
  end

  def create(conn, %{"school_id" => school_id, "teacher" => teacher_params}) do
    position = Teachers.get_position!(teacher_params["position"])
    school = Schools.get_school!(school_id)

    with {:ok, %User{} = user} <- Accounts.create_user_no_credential(teacher_params),
         {:ok, %Teacher{} = teacher} <- Teachers.create_teacher(%{user_id: user.id, school_id: school.id, position_id: position.id})
    do
      teacher = teacher |> Repo.preload([:position, :user])
      conn
      |> put_status(:created)
      |> render(:show, teacher: teacher)
    end
  end

  def show(conn, %{"id" => id}) do
    teacher = Teachers.get_teacher!(id) |> Repo.preload([:position, :user])
    render(conn, :show, teacher: teacher)
  end

  def update(conn, %{"school_id" => school_id, "id" => id, "teacher" => teacher_params}) do
    teacher = Teachers.get_teacher!(id)
    user = Accounts.get_user!(teacher.user_id)
    position = Teachers.get_position!(teacher_params["position"])
    school = Schools.get_school!(school_id)

    with {:ok, %User{} = user} <- Accounts.update_user_no_credential(user, teacher_params),
    {:ok, %Teacher{} = teacher} <- Teachers.update_teacher(teacher, %{user_id: user.id, school_id: school.id, position_id: position.id}) do
      teacher = teacher |> Repo.preload([:position, :user])
      render(conn, :show, teacher: teacher)
    end
  end

  def delete(conn, %{"id" => id}) do
    teacher = Teachers.get_teacher!(id)

    with {:ok, %Teacher{}} <- Teachers.delete_teacher(teacher) do
      send_resp(conn, :no_content, "")
    end
  end
end
