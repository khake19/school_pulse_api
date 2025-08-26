defmodule SchoolPulseApi.Schools do
  @moduledoc """
  The Schools context.
  """

  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo

  alias SchoolPulseApi.Schools.School
  alias SchoolPulseApi.Teachers
  alias SchoolPulseApi.Leaves
  alias SchoolPulseApi.Documents

  @doc """
  Returns the list of schools with pagination support.

  ## Examples

      iex> list_schools()
      %{entries: [%School{}, ...], meta: %{...}}

      iex> list_schools(%{"page" => 1, "page_size" => 10})
      %{entries: [%School{}, ...], meta: %{...}}

  """
  def list_schools(params \\ %{}, current_user) do
    base_query =
      from s in School,
        order_by: s.name

    query = filter_schools_by_role(base_query, current_user)

    {:ok, result} = Flop.validate_and_run(query, params, for: School)

    result
  end

  @doc """
  Gets a single school.

  Raises `Ecto.NoResultsError` if the School does not exist.

  ## Examples

      iex> get_school!(123)
      %School{}

      iex> get_school!(456)
      ** (Ecto.NoResultsError)

  """
  def get_school!(id), do: Repo.get!(School, id)

  @doc """
  Creates a school.

  ## Examples

      iex> create_school(%{field: value})
      {:ok, %School{}}

      iex> create_school(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_school(attrs \\ %{}) do
    %School{}
    |> School.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a school.

  ## Examples

      iex> update_school(school, %{field: new_value})
      {:ok, %School{}}

      iex> update_school(school, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_school(%School{} = school, attrs) do
    school
    |> School.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a school.

  ## Examples

      iex> delete_school(school)
      {:ok, %School{}}

      iex> delete_school(school)
      {:error, %Ecto.Changeset{}}

  """
  def delete_school(%School{} = school) do
    Repo.delete(school)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking school changes.

  ## Examples

      iex> change_school(school)
      %Ecto.Changeset{data: %School{}}

  """
  def change_school(%School{} = school, attrs \\ %{}) do
    School.changeset(school, attrs)
  end

  @doc """
  Returns aggregated counts for schools, teachers, documents, and leaves
  filtered by the current user's accessible schools. Admins get global counts.
  """
  def count_all_for_user(current_user) do
    # Base queries
    schools_query = from(s in School)
    schools_query = filter_schools_by_role(schools_query, current_user)

    %{
      schools: Repo.aggregate(schools_query, :count, :id),
      teachers: Teachers.count_teachers_for_user(current_user),
      documents: Documents.count_documents_for_user(current_user),
      leaves: Leaves.count_leaves_for_user(current_user)
    }
  end

  # teacher and leave filters moved to their contexts

  @doc """
  Returns the list of schools with summaries (currently teacher counts), supporting pagination.

  ## Examples

      iex> list_school_summaries()
      %{entries: [%{school: %School{}, teacher_count: 42}, ...], meta: %{...}}

      iex> list_school_summaries(%{"page" => 1, "page_size" => 10})
      %{entries: [%{school: %School{}, teacher_count: 42}, ...], meta: %{...}}

  """
  def list_school_summaries(params \\ %{}, current_user) do
    base_query =
      from s in School,
        left_join: t in assoc(s, :teachers),
        group_by: s.id,
        select: %{
          school: s,
          teacher_count: count(t.id)
        }

    query = filter_schools_by_role(base_query, current_user)

    {:ok, result} = Flop.validate_and_run(query, params, for: School)
    result
  end

  # ---- Role-based filtering ----

  defp filter_schools_by_role(query, %{role: %{name: "admin"}}), do: query

  defp filter_schools_by_role(query, %{role: %{name: "school admin"}, schools: schools}) do
    school_ids = for s <- schools, do: s.id
    from s in query, where: s.id in ^school_ids
  end
end
