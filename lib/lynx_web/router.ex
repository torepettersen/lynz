defmodule LynxWeb.Router do
  use LynxWeb, :router

  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LynxWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
    plug LynxWeb.Plugs.PutSessionId
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/", LynxWeb, host: "app." do
    pipe_through :browser

    ash_authentication_live_session :home,
      on_mount: {LynxWeb.LiveUserAuth, :user_optional} do
      live "/", HomeLive
    end

    ash_authentication_live_session :app,
      on_mount: {LynxWeb.LiveUserAuth, :user_optional} do
      live "/short-links", ShortLinksLive
      live "/short-link", ShortLinkLive
      live "/short-link/:id", ShortLinkLive

      get "/qr-code/:id", QRCodeController, :qr_code
    end

    ash_authentication_live_session :auth,
      layout: false,
      on_mount: {LynxWeb.LiveUserAuth, :no_user} do
      live "/sign-in", SignInLive, :sign_in
      live "/register", SignInLive, :register
    end

    sign_out_route AuthController
    auth_routes_for Lynx.Accounts.User, to: AuthController
  end

  scope "/", LynxWeb do
    pipe_through :browser

    get "/", RedirectController, :index
    get "/:code", RedirectController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LynxWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:lynx, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LynxWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
