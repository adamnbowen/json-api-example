defmodule JsonApiExample.Art.Band do
  @moduledoc """
  A single artist
  """
  use Ecto.Schema
  import Ecto.Changeset
  
  alias JsonApiExample.Art.Artist
  
  @primary_key false
  embedded_schema do
    field :type, :string
    field :name, :string
    embeds_many :artists, Artist
  end
  
  @doc false
  def changeset(%__MODULE__{} = solo_artist, attrs) do
    solo_artist
    |> cast(attrs, [:type, :name])
    |> cast_embed(:artists, required: true)
    |> validate_required([:type, :name])
  end
end