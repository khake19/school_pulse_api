defmodule SchoolPulseApi.Documents do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo

  alias SchoolPulseApi.Accounts.User
  alias SchoolPulseApi.Accounts.Document
  alias SchoolPulseApi.Accounts.DocumentType

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents(user_id \\ nil, params \\ %{}) do
    query =
      if is_nil(user_id) do
        from(t in Document)
      else
        from t in Document, where: t.user_id == ^user_id
      end

    query
    |> order_by([t], desc: t.inserted_at)
    |> preload([:user])
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
    |> User.changeset(attrs)
    |> Repo.update()
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

  def get_document_by_serial_id!(serial_id), do: Repo.get_by!(DocumentType, serial_id: serial_id)
end
