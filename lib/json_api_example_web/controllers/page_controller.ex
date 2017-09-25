defmodule JsonApiExampleWeb.PageController do
  use JsonApiExampleWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
