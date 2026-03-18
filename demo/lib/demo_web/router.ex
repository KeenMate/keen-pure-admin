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
      live "/tables-sizing", Live.TablesSizingLive, :index
      live "/tables-responsive", Live.TablesResponsiveLive, :index
      live "/table-filters", Live.TableFiltersLive, :index
      live "/modals", Live.ModalsLive, :index
      live "/modal-dialogs", Live.ModalDialogsLive, :index
      live "/popconfirm", Live.PopconfirmLive, :index
      live "/command-palette", Live.CommandPaletteLive, :index
      live "/tabs", Live.TabsLive, :index
      live "/grid", Live.GridLive, :index
      live "/forms", Live.FormsLive, :index
      live "/inputs", Live.InputsLive, :index
      live "/validations", Live.ValidationsLive, :index
      live "/checkbox-lists", Live.CheckboxListsLive, :index
      live "/toasts", Live.ToastsLive, :index
      live "/pagers", Live.PagersLive, :index
      live "/tooltips", Live.TooltipsLive, :index
      live "/loaders", Live.LoadersLive, :index
      live "/lists", Live.ListsLive, :index
      live "/timeline", Live.TimelineLive, :index
      live "/typography", Live.TypographyLive, :index
      live "/stats", Live.StatsLive, :index
      live "/callouts", Live.CalloutsLive, :index
      live "/code", Live.CodeLive, :index
      live "/data-display", Live.DataDisplayLive, :index
      live "/data-display-2", Live.DataDisplay2Live, :index
      live "/data-visualization", Live.DataVisualizationLive, :index
      live "/detail-panel", Live.DetailPanelLive, :index
    end
  end
end
