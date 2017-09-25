defmodule JsonApiExample.Repo.Migrations.AddUnprocessedWorksOfArt do
  use Ecto.Migration

  def change do
    rename table("works_of_art"), to: table("unprocessed_works_of_art")
    
    execute(
      "CREATE TYPE work_of_art_status AS ENUM ('queued', 'complete')")
    
    alter table(:unprocessed_works_of_art) do
      add :status, :work_of_art_status, null: false, default: "queued"
    end
    
    create table(:works_of_art, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :jsonb, null: false
      add :artist_names, {:array, :string}
      
      timestamps()
    end
  end
end
