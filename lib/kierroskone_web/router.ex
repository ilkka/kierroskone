defmodule KierroskoneWeb.Router do
  use KierroskoneWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {KierroskoneWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])

    plug(KierroskoneWeb.CheckApiAuth)
  end

  scope "/", KierroskoneWeb do
    pipe_through(:browser)

    # Traditional artesanal server side rendered routes
    get("/", PageController, :index)
    get("/dead/tracks", PageController, :tracks)
    get("/dead/tracks/:id", PageController, :track)
    get("/dead/unclaimed", PageController, :unclaimed)
    get("/dead/claim/:id", PageController, :claim)
    post("/dead/claim/:id", PageController, :submit_claim)
    get("/dead/laptimes/:id", PageController, :laptime)

    # Currently non-working (in prod) liveview stuff below this

    # GAMES
    live("/games", GameLive.Index, :index)
    live("/games/new", GameLive.Index, :new)
    live("/games/:id/edit", GameLive.Index, :edit)

    live("/games/:id", GameLive.Show, :show)
    live("/games/:id/show/edit", GameLive.Show, :edit)

    # TRACKS
    live "/tracks", TrackLive.Index, :index
    live "/tracks/new", TrackLive.Index, :new
    live "/tracks/:id/edit", TrackLive.Index, :edit

    live "/tracks/:id", TrackLive.Show, :show
    live "/tracks/:id/show/edit", TrackLive.Show, :edit

    # CLASSES
    live "/classes", ClassLive.Index, :index
    live "/classes/new", ClassLive.Index, :new
    live "/classes/:id/edit", ClassLive.Index, :edit

    live "/classes/:id", ClassLive.Show, :show
    live "/classes/:id/show/edit", ClassLive.Show, :edit

    # CARS
    live "/cars", CarLive.Index, :index
    live "/cars/new", CarLive.Index, :new
    live "/cars/:id/edit", CarLive.Index, :edit

    live "/cars/:id", CarLive.Show, :show
    live "/cars/:id/show/edit", CarLive.Show, :edit

    # USERS
    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit

    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit

    # LAPTIMES
    live "/laptimes", LaptimeLive.Index, :index
    live "/laptimes/new", LaptimeLive.Index, :new
    live "/laptimes/:id/edit", LaptimeLive.Index, :edit

    live "/laptimes/:id", LaptimeLive.Show, :show
    live "/laptimes/:id/show/edit", LaptimeLive.Show, :edit
  end

  scope "/api", KierroskoneWeb do
    pipe_through :api
    resources "/laptime-import/dirt2", Dirt2LaptimesUploadController, only: [:create]
    resources "/laptime-import/assettocorsa", AssettoCorsaLaptimesUploadController, only: [:create]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: KierroskoneWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
