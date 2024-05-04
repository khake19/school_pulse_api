defmodule SchoolPulseApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :school_pulse_api,
    module: SchoolPulseApiWeb.Auth.Guardian,
    error_handler: SchoolPulseApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
