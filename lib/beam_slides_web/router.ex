defmodule BeamSlidesWeb.Router do
  use BeamSlidesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BeamSlidesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", BeamSlidesWeb do
    pipe_through :browser
    live "/", SlideLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BeamSlidesWeb do
  #   pipe_through :api
  # end
end
