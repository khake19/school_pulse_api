defmodule SchoolPulseApiWeb.AuthController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Accounts.User

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = account} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account) do
      conn
      |> put_status(:created)
      |> render(:account_token, account: account, token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, account, token} ->
        conn
        |> put_status(:ok)
        |> render(:account_token, %{account: account, token: token})

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Email or password incorrect"
    end
  end

  def refresh_token(conn, %{}) do
    old_token = Guardian.Plug.current_token(conn)

    case Guardian.decode_and_verify(old_token) do
      {:ok, claims} ->
        case Guardian.resource_from_claims(claims) do
          {:ok, account} ->
            {:ok, _old, {new_token, _new_claims}} = Guardian.refresh(old_token)

            conn
            |> put_status(:ok)
            |> render(:account_token, %{account: account, token: new_token})

          {:error, _reason} ->
            raise ErrorResponse.NotFound
        end

      {:error, _reason} ->
        raise ErrorResponse.NotFound
    end
  end

  def sign_out(conn, %{}) do
    account = conn.assigns[:account]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)

    conn
    |> put_status(:ok)
    |> render(:account_token, %{account: account, token: token})
  end

  def me(conn, _) do
    current_user =
      Guardian.Plug.current_resource(conn)
      |> SchoolPulseApi.Repo.preload([:role])

    render(conn, :me, %{current_user: current_user})
  end
end
