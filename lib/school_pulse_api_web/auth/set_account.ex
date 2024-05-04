defmodule SchoolPulseApiWeb.Auth.SetAccount do
  import Plug.Conn
  alias SchoolPulseApiWeb.Auth.ErrorResponse

  def init(_options) do
  end

  def call(conn, _options) do
    account = Guardian.Plug.current_resource(conn)

    if account == nil, do: raise(ErrorResponse.Unauthorized)

    cond do
      account -> assign(conn, :account, account)
      true -> assign(conn, :account, nil)
    end
  end
end
