defmodule SchoolPulseApiWeb.AuthController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApiWeb.{Auth.Guardian, Auth.ErrorResponse}

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, account, token} ->
        conn
        |> put_status(:ok)
        |> render(:account_token, %{account: account, token: token})
      {:error, :unauthorized} -> raise ErrorResponse.Unauthorized, message: "Email or password incorrect"
    end
  end
end
