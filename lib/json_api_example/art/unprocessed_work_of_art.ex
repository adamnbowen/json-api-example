defmodule JsonApiExample.Art.UnprocessedWorkOfArt do
  @moduledoc """
  Represents a Work of Art
  """
  use Ecto.Schema
  import Ecto.Changeset
  
  alias JsonApiExample.Art.EmbeddedWorkOfArt
  
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "unprocessed_works_of_art" do
    field :status, :string
    embeds_one :body, EmbeddedWorkOfArt
    
    timestamps()
  end
  
  @doc false
  def changeset(%__MODULE__{} = work_of_art, attrs) do
    work_of_art
    |> cast(attrs, [:id])
    |> cast_embed(:body, required: true)
  end
end