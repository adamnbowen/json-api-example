defmodule JsonApiExample.Art do
  @moduledoc """
  Context for works of art and their artists
  """
  import Ecto.Query
  
  alias JsonApiExample.Repo
  alias JsonApiExample.Art.{UnprocessedWorkOfArt, WorkOfArt}
  
  def create_work_of_art(params, pid \\ nil)
  
  # TODO: Probably strange concurrency things can happen 
  # when one of the works of art is invalid and gets rolled back 
  # if others succeeded and have running tasks.
  def create_work_of_art(list, pid) when is_list(list) do
    Repo.transaction(fn ->
      Enum.map(list, fn (params) ->
        case create_work_of_art(params, pid) do
          {:ok, work_of_art} -> {:ok, work_of_art}
          {:error, changeset} -> Repo.rollback(changeset)
        end
      end)
    end)
  end
  
  def create_work_of_art(params, pid) do
    attrs = 
      case params do
        %{"id" => id} -> %{id: id, body: params}
        _ -> %{body: params}
      end
    
    with {:ok, unprocessed_work_of_art} <-
           %UnprocessedWorkOfArt{}
           |> UnprocessedWorkOfArt.changeset(attrs)
           |> Repo.insert do
      Task.Supervisor.async_nolink(
        JsonApiExample.TaskSupervisor,
        fn -> process_work_of_art(unprocessed_work_of_art.id, pid) end)
        
      {:ok, unprocessed_work_of_art}
    end
  end
  
  def process_work_of_art(id, pid) do
    unprocessed_work_of_art = 
      UnprocessedWorkOfArt
      |> Repo.get(id)
    
    body = 
      unprocessed_work_of_art.body
      |> Map.from_struct
      |> Map.merge(%{id: unprocessed_work_of_art.id})
    
    artist_names = 
      [
        get_in(body, [:artist]),
        get_in(body, [:artist, "artists"])]
      |> List.flatten
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&(&1["name"]))
      
    attrs = %{
      id: unprocessed_work_of_art.id,
      artist_names: artist_names,
      body: body}
      
    Repo.transaction(fn ->
      %WorkOfArt{} 
      |> WorkOfArt.changeset(attrs) 
      |> Repo.insert!
      
      unprocessed_work_of_art 
      |> UnprocessedWorkOfArt.changeset(%{status: "complete"})
      |> Repo.update!
    end)
    
    if pid, do: send(pid, :done)
  end
  
  def get_work_of_art(id) do
    case Repo.get(WorkOfArt, id) do
      nil -> {:error, :not_found}
      work_of_art -> {:ok, work_of_art}
    end
  end
  
  def list_works_of_art do
    WorkOfArt |> Repo.all
  end
  
  def list_works_of_art_by_artist(artist_name) do
    WorkOfArt 
    |> where([work_of_art], ^artist_name in work_of_art.artist_names)
    |> Repo.all
  end
end