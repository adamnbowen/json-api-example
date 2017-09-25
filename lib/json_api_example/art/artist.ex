defmodule JsonApiExample.Art.Artist do
  @moduledoc """
  A single artist
  """
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key false
  embedded_schema do
    field :type, :string
    field :name, :string
  end
  
  @doc false
  def changeset(%__MODULE__{} = artist, attrs) do
    artist
    |> cast(attrs, [:type, :name])
    |> validate_required([:type, :name])
  end
end