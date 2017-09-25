defmodule JsonApiExampleWeb.Router do
  use JsonApiExampleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JsonApiExampleWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", JsonApiExampleWeb do
    pipe_through :api
    
    resources "/works_of_art", WorkOfArtController
  end
end
