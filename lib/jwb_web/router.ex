defmodule JwbWeb.Router do
  use JwbWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JwbWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JwbWeb do
    pipe_through :browser

    live_session :app, on_mount: [{JwbWeb.CurrentURL, :current_path}] do
      live "/", HomeLive, :index

      live "/blog", BlogLive, :index
      live "/blog/:slug", BlogLive, :show

      live "/projects/:slug", ProjectsLive, :show

      live "/bookmarks", BookmarksLive, :index
      live "/things", ThingsLive, :index
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:jwb, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JwbWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
