defmodule JwbWeb.ProjectsLiveTest do
  use JwbWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "the overview links to every project and details return to the overview", %{conn: conn} do
    {:ok, overview, _html} = live(conn, ~p"/projects")

    for project <- Jwb.Projects.list_projects() do
      path = ~p"/projects/#{project.slug}"
      assert has_element?(overview, "main a[href='#{path}']")

      {:ok, detail, _html} = live(conn, path)
      assert has_element?(detail, "main h1", project.name)
      assert has_element?(detail, "main a[href='/projects']")
      assert has_element?(detail, "nav a[href='/projects'][aria-current='page']")
    end
  end

  test "an unknown project returns not found rather than a server error", %{conn: conn} do
    assert {404, _headers, "Not Found"} =
             assert_error_sent(404, fn -> get(conn, "/projects/not-a-project") end)
  end
end
