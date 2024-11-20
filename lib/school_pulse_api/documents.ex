defmodule SchoolPulseApi.Documents do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo
  alias SchoolPulseApi.Accounts.Document
  alias SchoolPulseApi.Accounts.DocumentType
  alias SchoolPulseApi.Accounts.User
  alias SchoolPulseApi.Teachers.Teacher
  alias SchoolPulseApi.Schools.School

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents(school_id \\ nil, params \\ %{}) do

    query =
      from d in Document,
        join: u in User, on: u.id == d.user_id,
        join: t in Teacher, on: t.user_id == u.id,
        join: s in School, on: s.id == t.school_id,
        where: s.id == ^school_id

    query
    |> order_by([d], desc: d.inserted_at)
    |> preload([:user, :document_type])
    |> Flop.validate_and_run(params, for: Document)
  end

  @doc """
  Gets a single document.

  Raises if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

  """
  def get_document!(id), do: Repo.get!(Document, id)

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, ...}

  """
  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, document} ->
        {:ok, Repo.preload(document, [:user, :document_type])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Updates a document.

  ## Examples

      iex> update_document(document, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(document, %{field: bad_value})
      {:error, ...}

  """
  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, document} ->
        {:ok, Repo.preload(document, [:user, :document_type])}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a Document.

  ## Examples

      iex> delete_document(document)
      {:ok, %Document{}}

      iex> delete_document(document)
      {:error, ...}

  """
  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  @doc """
  Returns a data structure for tracking document changes.

  ## Examples

      iex> change_document(document)
      %Todo{...}

  """
  def change_document(%Document{} = document, attrs \\ %{}) do
    Document.changeset(document, attrs)
  end

  def get_document_by_user_and_type(user_id, type_id) do
    query =
      from d in Document,
        where: d.user_id == ^user_id and d.document_type_id == ^type_id

    Repo.one(query)
  end

  def get_document_type_by_serial_id!(serial_id),
    do: Repo.get_by!(DocumentType, serial_id: serial_id)
end
