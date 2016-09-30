defmodule Badging.Router do
  use Badging.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Badging do
    pipe_through :api

    resources "/badges", BadgeController, except: [:new, :edit]
  end

  scope "/", Badging do
    get "/badges/:identifier_with_dot_svg", BadgeController, :show_svg
  end
end
