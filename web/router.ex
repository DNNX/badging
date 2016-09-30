defmodule Badging.Router do
  use Badging.Web, :router

  pipeline :api do
    plug :accepts, ["json", "svg"]
  end

  scope "/", Badging do
    pipe_through :api

    resources "/badges", BadgeController, except: [:new, :edit]
  end
end
