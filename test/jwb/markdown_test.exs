defmodule Jwb.MarkdownTest do
  use ExUnit.Case, async: true

  test "Markdown links cannot introduce executable attributes" do
    html = Jwb.Markdown.to_html!(~s|[click](http://example.com/?a=x" onerror="alert(1))|)
    document = Floki.parse_fragment!(html)

    assert Floki.find(document, "[onerror], [onclick], script") == []
  end

  test "raw HTML does not execute" do
    html = Jwb.Markdown.to_html!("<script>alert(1)</script>")
    assert Floki.find(Floki.parse_fragment!(html), "script") == []
  end

  test "trusted writing keeps automatic links and Makeup code highlighting" do
    html = Jwb.Markdown.to_html!("https://example.com\n\n```elixir\nIO.puts(\"hello\")\n```")
    document = Floki.parse_fragment!(html)

    assert Floki.attribute(document, "a", "href") == ["https://example.com"]
    assert Floki.find(document, "pre.highlight.makeup.elixir span") != []

    assert Floki.find(document, "pre code") |> Floki.text() |> String.trim() ==
             ~s|IO.puts("hello")|
  end
end
