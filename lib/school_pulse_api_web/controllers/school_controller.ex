defmodule SchoolPulseApiWeb.SchoolController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Schools
  alias SchoolPulseApi.Schools.School
  alias SchoolPulseApiWeb.Auth.Guardian
  alias SchoolPulseApi.Schools.Policy
  alias SchoolPulseApi.Repo
  alias SchoolPulseApi.Teachers
  alias SchoolPulseApi.Documents
  alias SchoolPulseApi.Leaves

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

  def counts(conn, %{"school_id" => school_id}) do
    current_user = conn |> Guardian.Plug.current_resource() |> Repo.preload([:role, :schools])
    school = Schools.get_school!(school_id) |> Repo.preload(:users)

    case Bodyguard.permit?(Policy, :count, current_user, school) do
      true ->
        counts = %{
          teachers: Teachers.count_teachers_by_school(school_id),
          documents: Documents.count_documents_by_school(school_id),
          leaves: Leaves.count_leaves_by_school(school_id)
        }

        render(conn, :counts, counts: counts)

      false ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Access denied - insufficient permissions"})
    end
  end

  def counts_all(conn, _params) do
    current_user = conn |> Guardian.Plug.current_resource() |> Repo.preload(:role)

    # Check if user has permission to view counts (admin only)
    with true <- Bodyguard.permit?(Policy, :count, current_user, %School{}) do
      counts = %{
        schools: Schools.count_schools(),
        teachers: Teachers.count_teachers(),
        documents: Documents.count_documents(),
        leaves: Leaves.count_leaves()
      }

      render(conn, :counts_all, counts: counts)
    else
      _ ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Access denied"})
    end
  end

  def school_summaries(conn, params) do
    current_user = conn |> Guardian.Plug.current_resource() |> Repo.preload([:role, :schools])

    school_summaries = Schools.list_school_summaries(params, current_user)
    render(conn, :school_summaries, school_summaries: school_summaries)
  end
end
