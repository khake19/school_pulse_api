defmodule SchoolPulseApiWeb.DocumentController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Repo
  alias SchoolPulseApi.Accounts.Document
  alias SchoolPulseApi.Teachers
  alias SchoolPulseApi.Documents
  alias SchoolPulseApi.FileUploader

  action_fallback SchoolPulseApiWeb.FallbackController

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, %{"school_id" => school_id}) do
    with {:ok, result} <- Documents.list_documents(school_id, conn.query_params) do
      render(conn, :index, documents: result)
    end
  end

  @spec create(any(), map()) :: any()
  def create(conn, %{"document" => document_params}) do
    teacher =
      Teachers.get_teacher!(document_params["teacher_id"])
      |> Repo.preload([:user])

    {:ok, stat} = File.lstat(document_params["file"].path)

    document_type = Documents.get_document_type_by_id!(document_params["document_type"])

    case Documents.get_document_by_type_and_date(
           teacher.user.id,
           document_type.id,
           document_params["date_period"]
         ) do
      nil ->
        case Documents.create_document(%{
               path: document_params["file"],
               user_id: teacher.user.id,
               document_type_id: document_type.id,
               size: stat.size,
               content_type: document_params["file"].content_type,
               date_period: document_params["date_period"]
             }) do
          {:ok, %Document{} = document} ->
            conn
            |> put_status(:created)
            |> render(:show, document: document)
        end

      document ->
        FileUploader.delete({document.path, document})

        case Documents.update_document(document, %{
               path: document_params["file"],
               user_id: teacher.user.id,
               document_type_id: document_type.id,
               size: stat.size,
               content_type: document_params["file"].content_type,
               date_period: document_params["date_period"]
             }) do
          {:ok, %Document{} = document} ->
            conn
            |> put_status(:created)
            |> render(:show, document: document)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    document = Documents.get_document!(id)
    render(conn, :show, document: document)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Documents.get_document!(id)

    with {:ok, %Document{} = document} <- Documents.update_document(document, document_params) do
      render(conn, :show, document: document)
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Documents.get_document!(id)

    FileUploader.delete({document.path, document})

    with {:ok, %Document{}} <- Documents.delete_document(document) do
      send_resp(conn, :no_content, "")
    end
  end
end
