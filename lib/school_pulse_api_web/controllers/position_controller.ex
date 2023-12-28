defmodule SchoolPulseApiWeb.PositionController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Teachers
  alias SchoolPulseApi.Teachers.Position

  action_fallback SchoolPulseApiWeb.FallbackController

  def index(conn, _params) do
    positions = Teachers.list_positions()
    render(conn, :index, positions: positions)
  end

  def create(conn, %{"position" => position_params}) do
    with {:ok, %Position{} = position} <- Teachers.create_position(position_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/positions/#{position}")
      |> render(:show, position: position)
    end
  end

  def show(conn, %{"id" => id}) do
    position = Teachers.get_position!(id)
    render(conn, :show, position: position)
  end

  def update(conn, %{"id" => id, "position" => position_params}) do
    position = Teachers.get_position!(id)

    with {:ok, %Position{} = position} <- Teachers.update_position(position, position_params) do
      render(conn, :show, position: position)
    end
  end

  def delete(conn, %{"id" => id}) do
    position = Teachers.get_position!(id)

    with {:ok, %Position{}} <- Teachers.delete_position(position) do
      send_resp(conn, :no_content, "")
    end
  end
end
