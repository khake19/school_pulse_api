defmodule SchoolPulseApiWeb.LeaveJSON do
  alias SchoolPulseApi.Leaves.Leave
  alias SchoolPulseApi.FileUploader

  @doc """
  Renders a list of leaves.
  """
  def index(%{leaves: leaves}) do
    {leaves, meta} = leaves
    %{data: for(leave <- leaves, do: data(leave)), meta: meta_data(meta)}
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

  # TODO:  make this globally
  defp meta_data(meta) do
    %{
      current_page: meta.current_page,
      current_offset: meta.current_offset,
      size: 1000,
      total: meta.total_count,
      pages: meta.total_pages
    }
  end
end
