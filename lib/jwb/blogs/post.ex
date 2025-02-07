defmodule Jwb.Blogs.Post do
  @enforce_keys [:slug, :title, :body, :description, :tags, :date]
  defstruct [:slug, :title, :body, :description, :tags, :date]

  @type t :: %__MODULE__{
          slug: String.t(),
          title: String.t(),
          description: String.t(),
          tags: [String.t()],
          date: Date.t(),
          body: String.t()
        }

  def parse!(post_path) do
    filename = Path.basename(post_path)
    [year, month, day, slug_with_md] = String.split(filename, "-", parts: 4)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")
    slug = Path.rootname(slug_with_md)

    contents = parse_contents(File.read!(post_path))

    %{date: date, slug: slug}
    struct!(__MODULE__, [slug: slug, date: date] ++ contents)
  end

  defp parse_contents(contents) do
    [frontmatter, body] = String.split(contents, "\n---\n", parts: 2)
    details = String.trim_leading(frontmatter, "---\n")

    # Parse details into key-value pairs
    detail_pairs =
      details
      |> String.split("\n")
      |> Enum.map(fn line ->
        [key, value] = String.split(line, ":", parts: 2)
        {String.trim(key) |> String.to_atom(), String.trim(value)}
      end)

    # Parse specific values and add body
    detail_pairs
    |> Enum.map(fn {key, value} ->
      {key, parse_attr(key, value)}
    end)
    |> Kernel.++([{:body, parse_attr(:body, body)}])
  end

  defp parse_attr(:body, body) do
    body |> Earmark.as_html!() |> Jwb.Blogs.Highlighter.highlight_code_blocks()
  end

  defp parse_attr(:tags, value) do
    value
    |> Jason.decode!()
    |> Enum.sort()
  end

  defp parse_attr(_, value), do: String.trim(value)
end
