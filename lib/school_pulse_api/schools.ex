defmodule SchoolPulseApi.Schools do
  @moduledoc """
  The Schools context.
  """

  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo

  alias SchoolPulseApi.Schools.School

  @doc """
  Returns the list of schools.

  ## Examples

      iex> list_schools()
      [%School{}, ...]

  """
  def list_schools do
    Repo.all(School) |> Repo.preload(:users)
  end

  def list_schools_for_user(user_id) do
    case Ecto.UUID.dump(user_id) do
      {:ok, binary_id} ->
        from(s in School,
          join: sa in "school_admins",
          on: sa.school_id == s.id,
          where: sa.user_id == ^binary_id
        )
        |> Repo.all()
        |> Repo.preload(:users)

      :error ->
        # Return empty list if user_id is invalid
        []
    end
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
end
