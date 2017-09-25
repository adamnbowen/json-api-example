defmodule JsonApiExampleWeb.FallbackController do
  use JsonApiExampleWeb, :controller
  alias JsonApiExampleWeb.ErrorView
  
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> render(ErrorView, "error.json", changeset: changeset)
  end
  
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, "error.json", message: "Not Found")
  end
  
  def call(conn, {:error, message}) do
    conn
    |> put_status(:bad_request)
    |> render(ErrorView, "error.json", message: message)
  end
end