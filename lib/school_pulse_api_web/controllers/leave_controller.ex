defmodule SchoolPulseApiWeb.LeaveController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Leaves
  alias SchoolPulseApi.Leaves.Leave

  action_fallback SchoolPulseApiWeb.FallbackController

  def index(conn, %{"school_id" => school_id}) do
    with {:ok, result} = Leaves.list_leaves(school_id, conn.query_params) do
      render(conn, :index, leaves: result)
    end
  end

  @spec create(
          any(),
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) ::
          {:error, any()}
          | {:ok, nil | [%{optional(atom()) => any()}] | %{optional(atom()) => any()}}
          | Plug.Conn.t()
  def create(conn, leave_params) do
    with {:ok, %Leave{} = leave} <- Leaves.create_leave(leave_params) do
      conn
      |> put_status(:created)
      |> render(:show, leave: leave)
    end
  end

  def show(conn, %{"id" => id}) do
    leave = Leaves.get_leave!(id)
    render(conn, :show, leave: leave)
  end

  @spec update(any(), any()) :: {:error, atom()} | {:ok, any()}
  def update(conn, %{"id" => id}) do
    leave = Leaves.get_leave!(id)

    with {:ok, %Leave{} = leave} <- Leaves.update_leave(leave, conn.body_params) do
      render(conn, :show, leave: leave)
    end
  end

  def delete(conn, %{"id" => id}) do
    leave = Leaves.get_leave!(id)

    with {:ok, %Leave{}} <- Leaves.delete_leave(leave) do
      send_resp(conn, :no_content, "")
    end
  end
end
