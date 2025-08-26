defmodule SchoolPulseApiWeb.SchoolController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Schools
  alias SchoolPulseApi.Schools.School
  alias SchoolPulseApiWeb.Auth.Guardian
  alias SchoolPulseApi.Repo

  action_fallback SchoolPulseApiWeb.FallbackController

  def index(conn, params) do
    current_user = conn |> Guardian.Plug.current_resource() |> Repo.preload([:role, :schools])

    schools = Schools.list_schools(params, current_user)

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

  def counts(conn, _params) do
    current_user = conn |> Guardian.Plug.current_resource() |> Repo.preload([:role, :schools])

    counts = Schools.count_all_for_user(current_user)
    render(conn, :counts, counts: counts)
  end

  def school_summaries(conn, params) do
    current_user = conn |> Guardian.Plug.current_resource() |> Repo.preload([:role, :schools])

    school_summaries = Schools.list_school_summaries(params, current_user)
    render(conn, :school_summaries, school_summaries: school_summaries)
  end
end
