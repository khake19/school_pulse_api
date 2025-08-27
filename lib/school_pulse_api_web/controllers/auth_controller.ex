defmodule SchoolPulseApiWeb.AuthController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias SchoolPulseApi.Accounts
  alias SchoolPulseApi.Accounts.User

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = account} <- Accounts.create_user(user_params),
         {:ok, access_token, _claims} <-
           Guardian.encode_and_sign(account, %{}, token_type: "access"),
         {:ok, refresh_token, _claims} <-
           Guardian.encode_and_sign(account, %{}, token_type: "refresh") do
      conn
      |> put_status(:created)
      |> render(:account_tokens,
        account: account,
        access_token: access_token,
        refresh_token: refresh_token
      )
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, account, access_token, refresh_token} ->
        conn
        |> put_status(:ok)
        |> render(:account_tokens, %{
          account: account,
          access_token: access_token,
          refresh_token: refresh_token
        })

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Email or password incorrect"
    end
  end

  def refresh_token(conn, %{"refresh_token" => refresh_token}) do
    case Guardian.refresh_access_token(refresh_token) do
      {:ok, account, new_access_token} ->
        conn
        |> put_status(:ok)
        |> render(:account_token, %{account: account, access_token: new_access_token})

      {:error, :token_expired} ->
        raise ErrorResponse.Unauthorized, message: "Refresh token has expired"

      {:error, :invalid_token} ->
        raise ErrorResponse.Unauthorized, message: "Invalid refresh token"

      {:error, _reason} ->
        raise ErrorResponse.Unauthorized, message: "Unable to refresh token"
    end
  end

  def refresh_token(_conn, _params) do
    raise ErrorResponse.BadRequest, message: "Refresh token is required"
  end

  def sign_out(conn, %{}) do
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)

    conn
    |> put_status(:ok)
    |> json(%{message: "Successfully signed out"})
  end

  def sign_out_all(conn, %{"refresh_token" => refresh_token}) do
    # Revoke the current access token
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)

    # Revoke the refresh token
    Guardian.revoke_refresh_token(refresh_token)

    conn
    |> put_status(:ok)
    |> json(%{message: "Successfully signed out from all devices"})
  end

  def me(conn, _) do
    current_user =
      Guardian.Plug.current_resource(conn)
      |> SchoolPulseApi.Repo.preload([:role])

    render(conn, :me, %{current_user: current_user})
  end
end
