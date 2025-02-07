defmodule Jwb.Projects.Project do
  @enforce_keys [:category, :slug, :name, :description, :cover, :gallery, :position, :body]
  defstruct [:category, :slug, :name, :description, :cover, :gallery, :position, :body]

  @type t :: %__MODULE__{
          slug: String.t(),
          name: String.t(),
          description: String.t(),
          category: String.t(),
          cover: String.t(),
          gallery: [String.t()],
          position: integer(),
          body: String.t()
        }

  def parse!(project_path) do
    slug = project_path |> Path.basename() |> Path.rootname()

    contents = parse_contents(File.read!(project_path))

    struct!(__MODULE__, [slug: slug] ++ contents)
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

    detail_pairs
    |> Enum.map(fn {key, value} ->
      {key, parse_attr(key, value)}
    end)
    |> Kernel.++([{:body, parse_attr(:body, body)}])
  end

  defp parse_attr(:body, body) do
    body |> Earmark.as_html!() |> Jwb.Blogs.Highlighter.highlight_code_blocks()
  end

  defp parse_attr(:gallery, value) do
    Jason.decode!(value)
  end

  defp parse_attr(_, value), do: String.trim(value)
end
