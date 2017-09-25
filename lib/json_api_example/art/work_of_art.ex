defmodule JsonApiExample.Art.WorkOfArt do
  @moduledoc """
  Represents a Work of Art
  """
  use Ecto.Schema
  import Ecto.Changeset
  
  alias JsonApiExample.Art.{ArtistType, EmbeddedWorkOfArt}
  
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "works_of_art" do
    field :artist_names, {:array, :string}
    field :body, :map
    
    timestamps()
  end
  
  @doc false
  def changeset(%__MODULE__{} = work_of_art, attrs) do
    work_of_art
    |> cast(attrs, [:id, :body, :artist_names])
    |> validate_required([:id, :body, :artist_names])
  end
end