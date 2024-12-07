defmodule SchoolPulseApiWeb.DocumentJSON do
  alias SchoolPulseApi.Accounts.Document
  alias SchoolPulseApi.FileUploader

  @doc """
  Renders a list of documents.
  """
  def index(%{documents: documents}) do
    {documents, meta} = documents
    %{data: for(document <- documents, do: data(document)), meta: meta_data(meta)}
  end

  @doc """
  Renders a single document.
  """
  def show(%{document: document}) do
    %{data: data(document)}
  end

  defp data(%Document{} = document) do
    %{
      id: document.id,
      path: FileUploader.url({document.path, document}, signed: true),
      filename: document.path.file_name,
      size: document.size,
      content_type: document.content_type,
      document_type: document.document_type.name,
      inserted_at: document.inserted_at,
      updated_at: document.updated_at,
      user: %{
        email: document.user.email,
        first_name: document.user.first_name,
        last_name: document.user.last_name,
        avatar: FileUploader.url({document.user.avatar, document.user}, signed: true)
      }
    }
  end

  # TODO:  make this globally
  defp meta_data(meta) do
    %{
      current_page: meta.current_page,
      current_offset: meta.current_offset,
      size: meta.page_size,
      total: meta.total_count,
      pages: meta.total_pages
    }
  end
end
