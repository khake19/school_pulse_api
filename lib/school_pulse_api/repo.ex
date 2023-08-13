defmodule SchoolPulseApi.Repo do
  use Ecto.Repo,
    otp_app: :school_pulse_api,
    adapter: Ecto.Adapters.Postgres
end
