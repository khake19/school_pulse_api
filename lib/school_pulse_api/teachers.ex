defmodule SchoolPulseApi.Teachers do
  @moduledoc """
  The Teachers context.
  """

  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo

  alias SchoolPulseApi.Teachers.Teacher
  alias SchoolPulseApi.Teachers.Position

  @doc """
  Returns the list of teachers.

  ## Examples

      iex> list_teachers()
      [%Teacher{}, ...]

  """
  def list_teachers(school_id \\ nil, params \\ %{}) do
    query =
      Teacher
      |> join(:left, [t], u in assoc(t, :user), as: :users)
      |> join(:left, [t], p in assoc(t, :position), as: :positions)
      |> where([t], t.school_id == ^school_id)

      position_ids = Map.get(params, "position_id")

      extra_filters =
        case position_ids do
          nil -> []
          [] -> []
          _ -> [%{field: :position_id, op: :in, value: position_ids}]
        end

      merged_params =
        Map.update(params, "filters", extra_filters, fn existing ->
          (existing || []) ++ extra_filters
        end)

    query
    |> order_by([t], desc: t.inserted_at)
    |> preload([:user, :school, :position])
    |> Flop.validate_and_run(merged_params, for: Teacher)
  end

  @doc """
  Gets a single teacher.

  Raises `Ecto.NoResultsError` if the Teacher does not exist.

  ## Examples

      iex> get_teacher!(123)
      %Teacher{}

      iex> get_teacher!(456)
      ** (Ecto.NoResultsError)

  """
  def get_teacher!(id), do: Repo.get!(Teacher, id)

  @doc """
  Creates a teacher.

  ## Examples

      iex> create_teacher(%{field: value})
      {:ok, %Teacher{}}

      iex> create_teacher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_teacher(attrs \\ %{}) do
    %Teacher{}
    |> Teacher.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a teacher.

  ## Examples

      iex> update_teacher(teacher, %{field: new_value})
      {:ok, %Teacher{}}

      iex> update_teacher(teacher, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_teacher(%Teacher{} = teacher, attrs) do
    teacher
    |> Teacher.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a teacher.

  ## Examples

      iex> delete_teacher(teacher)
      {:ok, %Teacher{}}

      iex> delete_teacher(teacher)
      {:error, %Ecto.Changeset{}}

  """
  def delete_teacher(%Teacher{} = teacher) do
    Repo.delete(teacher)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking teacher changes.

  ## Examples

      iex> change_teacher(teacher)
      %Ecto.Changeset{data: %Teacher{}}

  """
  def change_teacher(%Teacher{} = teacher, attrs \\ %{}) do
    Teacher.changeset(teacher, attrs)
  end

  alias SchoolPulseApi.Teachers.Position

  @doc """
  Returns the list of positions.

  ## Examples

      iex> list_positions()
      [%Position{}, ...]

  """
  def list_positions do
    Repo.all(Position)
  end

  def count_teachers() do
    Repo.aggregate(Teacher, :count, :id)
  end

  @doc """
  Counts teachers accessible to the given user.
  Admins get global counts; school admins are filtered by their schools.
  """
  def count_teachers_for_user(%{role: %{name: "admin"}}) do
    Repo.aggregate(Teacher, :count, :id)
  end

  def count_teachers_for_user(%{role: %{name: "school admin"}, schools: schools}) do
    school_ids = for s <- schools, do: s.id

    from(t in Teacher, where: t.school_id in ^school_ids)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single position.

  Raises `Ecto.NoResultsError` if the Position does not exist.

  ## Examples

      iex> get_position!(123)
      %Position{}

      iex> get_position!(456)
      ** (Ecto.NoResultsError)

  """
  def get_position!(id), do: Repo.get!(Position, id)

  @doc """
  Creates a position.

  ## Examples

      iex> create_position(%{field: value})
      {:ok, %Position{}}

      iex> create_position(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_position(attrs \\ %{}) do
    %Position{}
    |> Position.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a position.

  ## Examples

      iex> update_position(position, %{field: new_value})
      {:ok, %Position{}}

      iex> update_position(position, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_position(%Position{} = position, attrs) do
    position
    |> Position.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a position.

  ## Examples

      iex> delete_position(position)
      {:ok, %Position{}}

      iex> delete_position(position)
      {:error, %Ecto.Changeset{}}

  """
  def delete_position(%Position{} = position) do
    Repo.delete(position)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking position changes.

  ## Examples

      iex> change_position(position)
      %Ecto.Changeset{data: %Position{}}

  """
  def change_position(%Position{} = position, attrs \\ %{}) do
    Position.changeset(position, attrs)
  end
end
