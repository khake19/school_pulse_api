defmodule SchoolPulseApiWeb.SchoolJSON do
  alias SchoolPulseApi.Schools.School

  @doc """
  Renders a list of schools.
  """
  def index(%{schools: schools}) do
    %{data: for(school <- schools, do: data(school))}
  end

  @doc """
  Renders a single school.
  """
  def show(%{school: school}) do
    %{data: data(school)}
  end

  defp data(%School{} = school) do
    %{
      id: school.id,
      name: school.name
    }
  end
end
