defmodule SchoolPulseApiWeb.DocumentJSON do
  alias SchoolPulseApi.Accounts.Document
  alias SchoolPulseApi.FileUploader
  alias SchoolPulseApiWeb.SharedJSON

  @doc """
  Renders a list of documents.
  """
  def index(%{documents: documents}) do
    {documents, meta} = documents

    SharedJSON.paginated_response(
      for(document <- documents, do: data(document)),
      meta
    )
  end

  @doc """
  Renders a single document.
  """
  def show(%{document: document}) do
    %{data: data(document)}
  end

  def count(%{count: count}) do
    %{data: %{count: count}}
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
      date_period: document.date_period,
      user: %{
        email: document.user.email,
        first_name: document.user.first_name,
        middle_name: document.user.middle_name,
        last_name: document.user.last_name,
        avatar: FileUploader.url({document.user.avatar, document.user}, signed: true)
      }
    }
  end
end
