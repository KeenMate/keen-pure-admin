defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  live_session :default, on_mount: [{DemoWeb.Nav, :default}], layout: {DemoWeb.Layouts, :app} do
    scope "/", DemoWeb do
      pipe_through :browser

      live "/", Live.DashboardLive, :index
      live "/buttons", Live.ButtonsLive, :index
      live "/badges", Live.BadgesLive, :index
      live "/alerts", Live.AlertsLive, :index
      live "/cards", Live.CardsLive, :index
      live "/tables", Live.TablesLive, :index
      live "/modals", Live.ModalsLive, :index
      live "/tabs", Live.TabsLive, :index
      live "/grid", Live.GridLive, :index
      live "/forms", Live.FormsLive, :index
      live "/loaders", Live.LoadersLive, :index
      live "/lists", Live.ListsLive, :index
      live "/timeline", Live.TimelineLive, :index
      live "/typography", Live.TypographyLive, :index
      live "/stats", Live.StatsLive, :index
      live "/callouts", Live.CalloutsLive, :index
      live "/code", Live.CodeLive, :index
    end
  end
end
