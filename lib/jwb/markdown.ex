defmodule Jwb.Markdown do
  def to_html!(markdown) do
    markdown
    |> MDEx.to_html!(
      syntax_highlight: nil,
      parse: [smart: true],
      extension: [autolink: true, table: true, strikethrough: true]
    )
    |> Jwb.Blogs.Highlighter.highlight_code_blocks()
  end
end
