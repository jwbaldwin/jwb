defmodule Jwb.Blogs.Highlighter do
  @moduledoc """
  Performs code highlighting.
  """

  alias Makeup.Lexers.ElixirLexer
  alias Makeup.Lexers.DiffLexer
  alias Makeup.Lexers.JsonLexer
  alias Makeup.Lexers.HTMLLexer
  alias Makeup.Lexers.HEExLexer
  alias Makeup.Lexers.JsLexer
  alias Makeup.Registry

  defp pick_language_and_lexer(lang) do
    Registry.register_lexer(ElixirLexer, names: ["elixir", "iex"], extensions: ["ex", "exs"])
    Registry.register_lexer(DiffLexer, names: ["diff", "git"], extensions: ["diff", "patch"])
    Registry.register_lexer(JsonLexer, names: ["json"], extensions: ["json"])
    Registry.register_lexer(HTMLLexer, names: ["html"], extensions: ["html"])
    Registry.register_lexer(HEExLexer, names: ["heex", "html"], extensions: ["heex", "eex"])
    Registry.register_lexer(JsLexer, names: ["js", "ts"], extensions: ["js", "ts"])

    case Registry.fetch_lexer_by_name(lang) do
      {:ok, {lexer, opts}} ->
        {lang, lexer, opts}

      :error ->
        {lang, nil, []}
    end
  end

  @doc """
  Highlights all code block in an already generated HTML document.
  """
  def highlight_code_blocks(html, opts \\ []) do
    Regex.replace(
      ~r/<pre><code(?:\s+class="(\w*)")?>([^<]*)<\/code><\/pre>/,
      html,
      &highlight_code_block(&1, &2, &3, opts)
    )
  end

  defp highlight_code_block(full_block, lang, code, outer_opts) do
    case pick_language_and_lexer(lang) do
      {_language, nil, _opts} -> full_block
      {language, lexer, opts} -> render_code(language, lexer, opts, code, outer_opts)
    end
  end

  defp render_code(lang, lexer, lexer_opts, code, opts) do
    highlight_tag = Keyword.get(opts, :highlight_tag, "span")

    highlighted =
      code
      |> unescape_html()
      |> IO.iodata_to_binary()
      |> Makeup.highlight_inner_html(
        lexer: lexer,
        lexer_options: lexer_opts,
        formatter_options: [highlight_tag: highlight_tag]
      )

    ~s(<pre class="highlight makeup #{lang}"><code>#{highlighted}</code></pre>)
  end

  entities = [{"&amp;", ?&}, {"&lt;", ?<}, {"&gt;", ?>}, {"&quot;", ?"}, {"&#39;", ?'}]

  for {encoded, decoded} <- entities do
    defp unescape_html(unquote(encoded) <> rest) do
      [unquote(decoded) | unescape_html(rest)]
    end
  end

  defp unescape_html(<<c, rest::binary>>) do
    [c | unescape_html(rest)]
  end

  defp unescape_html(<<>>) do
    []
  end
end
