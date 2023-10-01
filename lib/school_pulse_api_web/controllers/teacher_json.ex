defmodule SchoolPulseApiWeb.TeacherJSON do
  alias SchoolPulseApi.Teachers.Teacher

  @doc """
  Renders a list of teachers.
  """
  def index(%{teachers: teachers}) do
    %{data: for(teacher <- teachers, do: data(teacher))}
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
      position: teacher.position
    }
  end
end
