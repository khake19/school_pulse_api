defmodule SchoolPulseApiWeb.DocumentController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Accounts.Document
  alias SchoolPulseApi.FileUploader

  action_fallback SchoolPulseApiWeb.FallbackController

  def index(conn, _params) do
    documents = Accounts.list_documents()
    render(conn, :index, documents: documents)
  end

  def create(conn, %{"document" => document_params}) do
    account = Guardian.Plug.current_resource(conn)
    FileUploader.store({document_params["file"], account})

    with {:ok, %Document{} = document} <- Accounts.create_document(document_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/documents/#{document}")
      |> render(:show, document: document)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Accounts.get_document!(id)
    render(conn, :show, document: document)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Accounts.get_document!(id)

    with {:ok, %Document{} = document} <- Accounts.update_document(document, document_params) do
      render(conn, :show, document: document)
    end
  end

  def delete(conn, %{"id" => id}) do
    document = Accounts.get_document!(id)

    with {:ok, %Document{}} <- Accounts.delete_document(document) do
      send_resp(conn, :no_content, "")
    end
  end
end
