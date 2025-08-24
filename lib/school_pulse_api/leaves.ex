defmodule SchoolPulseApi.Leaves do
  @moduledoc """
  The Leaves context.
  """

  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo

  alias SchoolPulseApi.Leaves.Leave
  alias SchoolPulseApi.Teachers.Teacher
  alias SchoolPulseApi.Schools.School

  @doc """
  Returns the list of leaves.

  ## Examples

      iex> list_leaves()
      [%Leave{}, ...]

  """
  def list_leaves(school_id \\ nil, params \\ %{}) do
    teacher_id = Map.get(params, "teacher_id")
    start_at = Map.get(params, "start_at")
    end_at = Map.get(params, "end_at")

    query =
      from l in Leave,
        join: t in Teacher,
        on: t.id == l.teacher_id,
        join: s in School,
        on: s.id == ^school_id

    query =
      query
      |> maybe_filter_teacher(teacher_id)
      |> maybe_filter_start_at(start_at)
      |> maybe_filter_end_at(end_at)

    query
    |> order_by([l], desc: l.inserted_at)
    |> preload(teacher: [:user])
    |> Flop.validate_and_run(params, for: Leave)
  end

  defp maybe_filter_teacher(query, nil), do: query

  defp maybe_filter_teacher(query, teacher_id) do
    from [_, _, t] in query, where: t.id == ^teacher_id
  end

  defp maybe_filter_start_at(query, nil), do: query

  defp maybe_filter_start_at(query, start_at) do
    from l in query, where: l.start_at >= ^start_at
  end

  defp maybe_filter_end_at(query, nil), do: query

  defp maybe_filter_end_at(query, end_at) do
    from l in query, where: l.end_at <= ^end_at
  end

  @doc """
  Gets a single leave.

  Raises `Ecto.NoResultsError` if the Leave does not exist.

  ## Examples

      iex> get_leave!(123)
      %Leave{}

      iex> get_leave!(456)
      ** (Ecto.NoResultsError)

  """
  def get_leave!(id), do: Repo.get!(Leave, id)

  @doc """
  Creates a leave.

  ## Examples

      iex> create_leave(%{field: value})
      {:ok, %Leave{}}

      iex> create_leave(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leave(attrs \\ %{}) do
    %Leave{}
    |> Leave.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, leave} ->
        {:ok, Repo.preload(leave, teacher: [:user])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a leave.

  ## Examples

      iex> update_leave(leave, %{field: new_value})
      {:ok, %Leave{}}

      iex> update_leave(leave, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leave(%Leave{} = leave, attrs) do
    leave
    |> Leave.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, leave} ->
        {:ok, Repo.preload(leave, teacher: [:user])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a leave.

  ## Examples

      iex> delete_leave(leave)
      {:ok, %Leave{}}

      iex> delete_leave(leave)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leave(%Leave{} = leave) do
    Repo.delete(leave)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leave changes.

  ## Examples

      iex> change_leave(leave)
      %Ecto.Changeset{data: %Leave{}}

  """
  def change_leave(%Leave{} = leave, attrs \\ %{}) do
    Leave.changeset(leave, attrs)
  end

  @doc """
  Counts leaves for a given school.

  ## Examples

      iex> count_leaves_by_school("school-id")
      8

  """
  def count_leaves_by_school(school_id) do
    from(l in Leave,
      join: t in Teacher,
      on: t.id == l.teacher_id,
      where: t.school_id == ^school_id
    )
    |> Repo.aggregate(:count, :id)
  end

  def count_leaves() do
    Repo.aggregate(Leave, :count, :id)
  end
end
