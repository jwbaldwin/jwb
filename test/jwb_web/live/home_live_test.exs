defmodule JwbWeb.HomeLiveTest do
  use JwbWeb.ConnCase

  test "the homepage links to the projects overview, writing, and collections", %{conn: conn} do
    conn = get(conn, ~p"/")
    homepage = conn |> html_response(200) |> Floki.parse_document!()
    destinations = homepage |> Floki.find("main a") |> Floki.attribute("href")

    for destination <- [~p"/projects", ~p"/blog", ~p"/things"] do
      assert destination in destinations
    end
  end
end
