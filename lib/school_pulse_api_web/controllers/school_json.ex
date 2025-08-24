defmodule SchoolPulseApiWeb.SchoolJSON do
  alias SchoolPulseApi.Schools.School
  alias SchoolPulseApiWeb.SharedJSON

  @doc """
  Renders a list of schools.
  """
  def index(%{schools: schools}) do
    {schools, meta} = schools

    SharedJSON.paginated_response(
      for(school <- schools, do: data(school)),
      meta
    )
  end

  @doc """
  Renders a single school.
  """
  def show(%{school: school}) do
    %{data: data(school)}
  end

  def count(%{count: count}) do
    %{data: %{count: count}}
  end

  def counts(%{counts: counts}) do
    %{data: counts}
  end

  def counts_all(%{counts: counts}) do
    %{data: counts}
  end

  def school_summaries(%{school_summaries: school_summaries}) do
    {schools, meta} = school_summaries

    SharedJSON.paginated_response(
      for(
        %{school: school, teacher_count: count} <- schools,
        do: %{
          id: school.id,
          name: school.name,
          teacher_count: count
        }
      ),
      meta
    )
  end

  defp data(%School{} = school) do
    %{
      id: school.id,
      name: school.name
    }
  end
end
