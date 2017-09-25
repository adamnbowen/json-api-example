defmodule JsonApiExample.Art.EmbeddedWorkOfArt do
  @moduledoc """
  The internal structure of a WorkOfArt.
  """
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Ecto.UUID
  alias JsonApiExample.Art.ArtistType
  
  @primary_key false
  embedded_schema do
    field :id, UUID
    field :title, :string
    field :artist, ArtistType
  end
  
  def changeset(%__MODULE__{} = embedded_work_of_art, attrs) do
    embedded_work_of_art
    |> cast(attrs, [:title, :artist])
    |> validate_required([:title, :artist])
  end
end