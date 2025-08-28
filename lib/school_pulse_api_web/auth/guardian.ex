defmodule SchoolPulseApiWeb.Auth.Guardian do
  use Guardian, otp_app: :school_pulse_api

  alias SchoolPulseApi.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def refresh_access_token(refresh_token) do
    case decode_and_verify(refresh_token, %{}, token_type: "refresh") do
      {:ok, claims} ->
        case resource_from_claims(claims) do
          {:ok, user} ->
            # Create new access token
            {:ok, new_access_token, _claims} = encode_and_sign(user, %{}, token_type: "access")
            {:ok, user, new_access_token}

          {:error, reason} ->
            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil ->
        {:error, :unauthorized}

      account ->
        case validate_password(password, account.password) do
          true -> create_token(account)
          false -> {:error, :unauthorized}
        end
    end
  end

  defp validate_password(password, hash_password) do
    Argon2.verify_pass(password, hash_password)
  end

  defp create_token(account) do
    # Create access token (short-lived)
    {:ok, access_token, _claims} =
      encode_and_sign(account, %{}, token_type: "access", ttl: {15, :seconds})

    # Create refresh token (long-lived)
    {:ok, refresh_token, _claims} = encode_and_sign(account, %{}, token_type: "refresh")

    {:ok, account, access_token, refresh_token}
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end

  def revoke_refresh_token(refresh_token) do
    case decode_and_verify(refresh_token, %{}, token_type: "refresh") do
      {:ok, claims} ->
        Guardian.revoke(SchoolPulseApiWeb.Auth.Guardian, refresh_token, [])
        {:ok, claims}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
