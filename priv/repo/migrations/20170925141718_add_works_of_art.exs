defmodule JsonApiExample.Repo.Migrations.AddWorksOfArt do
  use Ecto.Migration

  def change do
    create table(:works_of_art, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :jsonb, null: false
      
      timestamps()
    end
  end
end
