defmodule SchoolPulseApiWeb.AuthController do
  use SchoolPulseApiWeb, :controller

  alias SchoolPulseApiWeb.Auth.Guardian
  alias SchoolPulseApi.Accounts

  def get_token(conn, _params) do
    user = Accounts.get_user!(1)
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

    dbg(jwt)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{token: jwt}))
  end
end
