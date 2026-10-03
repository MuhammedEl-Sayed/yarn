defmodule SpoolWeb.Router do
  use SpoolWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SpoolWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug AshAuthentication.Strategy.ApiKey.Plug,
      resource: Spool.Accounts.User,
      required?: true

    # Hand the authenticated user to Ash so policies can see the actor
    plug :set_ash_actor
  end

  # Dev routes come FIRST: the catch-all forward below would otherwise
  # swallow /dev/dashboard and /dev/mailbox.
  if Application.compile_env(:spool, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SpoolWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", SpoolWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/" do
    pipe_through :api

    forward "/", SpoolWeb.AshJsonApiRouter
  end

  defp set_ash_actor(conn, _opts) do
    Ash.PlugHelpers.set_actor(conn, conn.assigns[:current_user])
  end
end
