defmodule SchoolPulseApiWeb.PositionJSON do
  alias SchoolPulseApi.Teachers.Position

  @doc """
  Renders a list of positions.
  """
  def index(%{positions: positions}) do
    %{data: for(position <- positions, do: data(position))}
  end

  @doc """
  Renders a single position.
  """
  def show(%{position: position}) do
    %{data: data(position)}
  end

  defp data(%Position{} = position) do
    %{
      id: position.id,
      name: position.name,
      salary_grade: position.salary_grade,
      type: position.type
    }
  end
end
