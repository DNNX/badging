defmodule Badging.Router do
  use Badging.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Badging do
    pipe_through :api
  end
end
