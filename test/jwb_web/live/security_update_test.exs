defmodule JwbWeb.SecurityUpdateTest do
  use JwbWeb.ConnCase

  import Phoenix.LiveViewTest

  test "public pages mount connected LiveViews", %{conn: conn} do
    for path <- ["/", "/blog", "/projects", "/things"] do
      assert {:ok, view, _html} = live(conn, path)
      assert has_element?(view, "main")
    end
  end

  test "local redirects reject browser-stripped control characters" do
    for character <- ["\t", "\n", "\r"] do
      assert_raise ArgumentError, fn ->
        Phoenix.LiveView.redirect(%Phoenix.LiveView.Socket{}, to: "/#{character}/example.com")
      end
    end
  end

  test "every blog post mounts with its rendered content", %{conn: conn} do
    for post <- Jwb.Blogs.list_posts() do
      assert {:ok, view, _html} = live(conn, "/blog/#{post.slug}")
      assert has_element?(view, "main h1", post.title)
    end
  end

  test "HTTP and socket transports remain available" do
    server = start_supervised!({Bandit, plug: JwbWeb.Endpoint, ip: {127, 0, 0, 1}, port: 0})
    {:ok, {_address, port}} = ThousandIsland.listener_info(server)

    for path <- ["/", "/blog", "/projects", "/things"] do
      assert {:ok, %{status: 200, body: body}} =
               Finch.build(:get, "http://127.0.0.1:#{port}#{path}") |> Finch.request(Jwb.Finch)

      assert body =~ "data-phx-session"
    end

    assert {:ok, %{status: 200, body: body}} =
             Finch.build(:get, "http://127.0.0.1:#{port}/live/longpoll?vsn=2.0.0")
             |> Finch.request(Jwb.Finch)

    assert %{"status" => 410, "token" => token} = Jason.decode!(body)
    assert is_binary(token)

    {:ok, socket} = :gen_tcp.connect({127, 0, 0, 1}, port, [:binary, active: false])

    :ok =
      :gen_tcp.send(socket, [
        "GET /live/websocket?vsn=2.0.0 HTTP/1.1\r\n",
        "Host: localhost\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n",
        "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13\r\n\r\n"
      ])

    assert {:ok, response} = :gen_tcp.recv(socket, 0, 5_000)
    assert response =~ "101 Switching Protocols"
    :gen_tcp.close(socket)
  end
end
