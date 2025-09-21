defmodule SchoolPulseApi.Activities do
  @moduledoc """
  The Activities context.
  """
  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo

  alias SchoolPulseApi.Activities.Activity

  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  def create_activity_with_context(conn, attrs) do
    user = conn.assigns.account

    activity_attrs =
      attrs
      |> Map.put(:user_id, user.id)
      |> Map.put(:ip_address, get_ip_address(conn))
      |> Map.put(:user_agent, get_user_agent(conn))

    create_activity(activity_attrs)
  end

  def get_ip_address(conn) do
    conn.remote_ip
    |> :inet.ntoa()
    |> to_string()
  end

  def get_user_agent(conn) do
    Plug.Conn.get_req_header(conn, "user-agent")
    |> List.first()
    |> case do
      nil -> "Unknown"
      ua -> ua
    end
  end
end
