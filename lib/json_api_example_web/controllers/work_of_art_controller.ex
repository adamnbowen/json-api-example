defmodule JsonApiExampleWeb.WorkOfArtController do
  use JsonApiExampleWeb, :controller

  alias JsonApiExample.Art
  
  action_fallback JsonApiExampleWeb.FallbackController

  def index(conn, %{"id" => id}) do
    with {:ok, work_of_art} <- Art.get_work_of_art(id),
         {:ok, body} <- Poison.encode(work_of_art.body) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(:ok, body)
    end
  end
  
  def index(conn, %{"artist_name" => name}) do
    with works_of_art <- Art.list_works_of_art_by_artist(name),
         list <- Enum.map(works_of_art, &(&1.body)),
         {:ok, body} <- Poison.encode(list) do
           
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(:ok, body)
    end
  end
  
  def index(conn, _) do
    with works_of_art <- Art.list_works_of_art,
         list <- Enum.map(works_of_art, &(&1.body)),
         {:ok, body} <- Poison.encode(list) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(:ok, body)
    end
  end

  def create(conn, %{"_json" => params}) do
    pid = conn.private[:notify_pid_when_done]
    with {:ok, _works_of_art} <- Art.create_work_of_art(params, pid) do
      conn
      |> send_resp(:no_content, "")
    end
  end

  def create(conn, %{"id" => _} = params) do
    pid = conn.private[:notify_pid_when_done]
    with {:ok, work_of_art} <- Art.create_work_of_art(params, pid) do
      conn
      |> send_resp(:no_content, "")
    end
  end

  def create(conn, params) do
    pid = conn.private[:notify_pid_when_done]
    with {:ok, work_of_art} <- Art.create_work_of_art(params, pid),
         {:ok, body} <- Poison.encode(%{"id" => work_of_art.id}) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(:ok, body)
    end
  end
end
