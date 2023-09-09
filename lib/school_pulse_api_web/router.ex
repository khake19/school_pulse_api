defmodule SchoolPulseApiWeb.Router do
  use SchoolPulseApiWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug SchoolPulseApiWeb.Auth.Pipeline
    plug SchoolPulseApiWeb.Auth.SetAccount
  end

  scope "/api", SchoolPulseApiWeb do
    pipe_through :api
    post "/auth/sign_up", AuthController, :sign_up
    post "/auth/sign_in", AuthController, :sign_in

  end

  scope "/api", SchoolPulseApiWeb do
    pipe_through [:api, :auth]
    resources "/users", UserController, only: [:index, :show]
    get "/auth/sign_out", AuthController, :sign_out
    get "/auth/refresh_token", AuthController, :refresh_token
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:school_pulse_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: SchoolPulseApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
