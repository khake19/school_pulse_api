defmodule SchoolPulseApiWeb.LeaveJSON do
  alias SchoolPulseApi.Leaves.Leave
  alias SchoolPulseApi.FileUploader
  alias SchoolPulseApiWeb.SharedJSON

  @doc """
  Renders a list of leaves.
  """
  def index(%{leaves: leaves}) do
    {leaves, meta} = leaves

    SharedJSON.paginated_response(
      for(leave <- leaves, do: data(leave)),
      meta
    )
  end

  @doc """
  Renders a single leave.
  """
  def show(%{leave: leave}) do
    %{data: data(leave)}
  end

  defp data(%Leave{} = leave) do
    %{
      id: leave.id,
      remarks: leave.remarks,
      type: leave.type,
      start_at: leave.start_at,
      end_at: leave.end_at,
      inserted_at: leave.inserted_at,
      updated_at: leave.updated_at,
      user: %{
        id: leave.teacher.id,
        email: leave.teacher.user.email,
        first_name: leave.teacher.user.first_name,
        middle_name: leave.teacher.user.middle_name,
        last_name: leave.teacher.user.last_name,
        avatar: FileUploader.url({leave.teacher.user.avatar, leave.teacher.user}, signed: true)
      }
    }
  end
end
