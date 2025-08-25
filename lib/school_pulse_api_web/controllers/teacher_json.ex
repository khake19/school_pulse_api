defmodule SchoolPulseApiWeb.TeacherJSON do
  alias SchoolPulseApi.Teachers.Teacher
  alias SchoolPulseApiWeb.SharedJSON
  alias SchoolPulseApi.Avatar

  @doc """
  Renders a list of teachers.
  """
  def index(%{teachers: teachers}) do
    {teachers, meta} = teachers

    SharedJSON.paginated_response(
      for(teacher <- teachers, do: data(teacher)),
      meta
    )
  end

  @doc """
  Renders a single teacher.
  """
  def show(%{teacher: teacher}) do
    %{data: data(teacher)}
  end

  defp data(%Teacher{} = teacher) do
    %{
      id: teacher.id,
      first_name: teacher.user.first_name,
      middle_name: teacher.user.middle_name,
      last_name: teacher.user.last_name,
      suffix: teacher.user.suffix,
      email: teacher.user.email,
      gender: teacher.user.gender,
      avatar: Avatar.url({teacher.user.avatar, teacher.user}, signed: true),
      employee_number: teacher.employee_number,
      philhealth: teacher.philhealth,
      gsis: teacher.gsis,
      pagibig: teacher.pagibig,
      tin: teacher.tin,
      plantilla: teacher.plantilla,
      date_hired: teacher.date_hired,
      date_promotion: teacher.date_promotion,
      position:
        teacher.position &&
          %{
            id: teacher.position.id,
            name: teacher.position.name,
            salary_grade: teacher.position.salary_grade,
            type: teacher.position.type
          },
    }
  end

  def count(%{count: count}) do
    %{data: %{count: count}}
  end
end
