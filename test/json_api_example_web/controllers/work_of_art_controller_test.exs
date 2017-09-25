defmodule JsonApiExampleWeb.WorkOfArtControllerTest do
  use JsonApiExampleWeb.ConnCase

  setup %{conn: conn} do
    {
      :ok, 
      conn: 
        conn
        |> Plug.Conn.put_req_header("accept", "application/json")
        |> put_private(:notify_pid_when_done, self())}
  end

  @animal %{title: "Animal", artist: %{type: "Artist", name: "Kesha"}}
  @love_this_giant %{ 
    title: "Love This Giant", 
    artist: %{ 
      type: "Band", 
      name: "David Byrne & St. Vincent",
      artists: [
        %{type: "Artist", name: "St. Vincent"}, 
        %{type: "Artist", name: "David Byrne"}]}}
  
  alias JsonApiExample.Art.WorkOfArt
  alias JsonApiExample.Repo
  
  test "POST solo artist work to /api/works_of_art", %{conn: conn} do
    conn = post conn, "/api/works_of_art", @animal
    id = json_response(conn, 200)["id"]
    assert_receive :done
    assert Repo.get(WorkOfArt, id)
  end

  test "POST band work to /api/works_of_art", %{conn: conn} do
    conn = post conn, "/api/works_of_art", @love_this_giant
    id = json_response(conn, 200)["id"]
    assert_receive :done
    assert Repo.get(WorkOfArt, id)
  end
  

  test "POST with id to /api/works_of_art", %{conn: conn} do
    love_this_giant = 
      @love_this_giant 
      |> Map.merge(%{id: "a93a9a9d-732a-4dd1-b0de-dc40ca19d921"})
      
    conn = post conn, "/api/works_of_art", love_this_giant
    response(conn, 204)
    assert_receive :done
    assert Repo.get(WorkOfArt, "a93a9a9d-732a-4dd1-b0de-dc40ca19d921")
  end
  
  test "Works of art can be queried by id", %{conn: conn} do
    post_conn = post conn, "/api/works_of_art", @love_this_giant
    id = json_response(post_conn, 200)["id"]
    assert_receive :done
    get_conn = get conn, "/api/works_of_art?id=#{id}"
    json = json_response(get_conn, 200)
    assert json["title"] == "Love This Giant"
    assert json["artist"]["name"] == "David Byrne & St. Vincent"
    assert Enum.at(json["artist"]["artists"], 0)["name"] == "St. Vincent"
  end
  
  test "Can post multiple works of art at once", %{conn: conn} do
    conn = put_req_header(conn, "content-type", "application/json")
    
    love_this_giant = 
      @love_this_giant 
      |> Map.merge(%{id: "ae516cc9-363b-44e2-bda2-f3da3f913768"})
      
    animal = 
      @animal 
      |> Map.merge(%{id: "c2c62996-a1f0-4f8e-9e95-a0a56cd953a4"})
      
    post_body = Poison.encode! [love_this_giant, animal]
    post_conn = post conn, "/api/works_of_art", post_body
    
    assert response(post_conn, 204)
    assert_receive :done
    assert_receive :done
    
    get_conn = get conn, "/api/works_of_art?id=#{love_this_giant.id}"
    json = json_response(get_conn, 200)
    assert json["title"] == "Love This Giant"
    assert json["artist"]["name"] == "David Byrne & St. Vincent"
    assert Enum.at(json["artist"]["artists"], 0)["name"] == "St. Vincent"
    
    get_conn = get conn, "/api/works_of_art?id=#{animal.id}"
    json = json_response(get_conn, 200)
    assert json["title"] == "Animal"
    assert json["artist"]["name"] == "Kesha"
  end
  
  test "can return an empty list of works of art", %{conn: conn} do
    conn = get conn, "/api/works_of_art"
    assert json_response(conn, 200) == []
  end
  
  test "can return all existing works of art", %{conn: conn} do
    post_conn = post conn, "/api/works_of_art", @love_this_giant
    id = json_response(post_conn, 200)["id"]
    assert_receive :done
    get_conn = get conn, "/api/works_of_art"
    json = Enum.at(json_response(get_conn, 200), 0)
    assert json["id"] == id
    assert json["title"] == "Love This Giant"
    assert json["artist"]["name"] == "David Byrne & St. Vincent"
    assert Enum.at(json["artist"]["artists"], 0)["name"] == "St. Vincent"
  end
  
  test "querying for nonexistent art returns 404", %{conn: conn} do
    conn = get(
      conn, "/api/works_of_art?id=" <> "99c327a3-2c60-4a80-bcc0-adbb9b4bc52f")
    assert json_response(conn, 404)["error"]["message"] == "Not Found"
  end
  
  
  test "can return all existing works of art by name", %{conn: conn} do
    post_conn = post conn, "/api/works_of_art", @love_this_giant
    id = json_response(post_conn, 200)["id"]
    assert_receive :done
    
    post_conn = post conn, "/api/works_of_art", @animal
    json_response(post_conn, 200)["id"]
    assert_receive :done
    
    get_conn = get(
      conn, 
      "/api/works_of_art?" 
        <> URI.encode_query(%{"artist_name" => "St. Vincent"}))
    json = json_response(get_conn, 200)
    assert length(json) == 1
    kesha_json = Enum.at(json, 0)
    assert kesha_json["id"] == id
    assert kesha_json["title"] == "Love This Giant"
    assert kesha_json["artist"]["name"] == "David Byrne & St. Vincent"
  end
end
