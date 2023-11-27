defmodule SchoolPulseApiWeb.SchoolController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Schools
  alias SchoolPulseApi.Schools.School

  action_fallback SchoolPulseApiWeb.FallbackController

  def index(conn, _params) do
    schools = Schools.list_schools()
    render(conn, :index, schools: schools)
  end

  def create(conn, %{"school" => school_params}) do
    with {:ok, %School{} = school} <- Schools.create_school(school_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/schools/#{school}")
      |> render(:show, school: school)
    end
  end

  def show(conn, %{"id" => id}) do
    school = Schools.get_school!(id)
    render(conn, :show, school: school)
  end

  def update(conn, %{"id" => id, "school" => school_params}) do
    school = Schools.get_school!(id)

    with {:ok, %School{} = school} <- Schools.update_school(school, school_params) do
      render(conn, :show, school: school)
    end
  end

  def delete(conn, %{"id" => id}) do
    school = Schools.get_school!(id)

    with {:ok, %School{}} <- Schools.delete_school(school) do
      send_resp(conn, :no_content, "")
    end
  end
end
