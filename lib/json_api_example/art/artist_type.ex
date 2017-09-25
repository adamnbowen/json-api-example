defmodule JsonApiExample.Art.ArtistType do
  @moduledoc """
  Validates a number of artist types by using their changesets.
  """
  
  @behaviour Ecto.Type
  
  alias JsonApiExample.Art.{Band, Artist}
  
  @impl Ecto.Type
  def type, do: :map
  
  @impl Ecto.Type
  def cast(%{"type" => "Band"} = map), do: cast_changeset(Band, map)
  def cast(%{"type" => "Artist"} = map), do: cast_changeset(Artist, map)
  
  def cast(_), do: :error
  
  defp cast_changeset(module, map) do
    changeset = apply(module, :changeset, [struct(module), map])

    case changeset.valid? do
      true -> {:ok, map}
      false -> :error
    end
  end
  
  @impl Ecto.Type
  def load(map) when is_map(map), do: {:ok, map}

  @impl Ecto.Type
  def dump(map) when is_map(map), do: {:ok, map}
  def dump(_), do: :error
end