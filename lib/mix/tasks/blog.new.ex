defmodule Mix.Tasks.Blog.New do
  @moduledoc """
  Create a new blog post, pass in the title of the post as the first argument.

  ## Usage

      mix blog.new "My Post Title"
  """
  @shortdoc "Create a new blog post"
  use Mix.Task

  def run([title]) do
    [year, month, day] = Date.utc_today() |> Date.to_iso8601() |> String.split("-")

    slug =
      title
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/\s+/, "-")

    filename = "#{year}-#{month}-#{day}-#{slug}.md"
    path = "lib/jwb/blogs/#{filename}"

    contents = """
    ---
    slug: #{slug}
    title: #{title}
    description: 
    tags: []
    ---
    """

    File.write!(path, contents)
    Mix.shell().info("✅ Blog post created at #{path}")
  end

  def run(_) do
    Mix.shell().error("Usage: mix blog.new \"My Post Title\"")
  end
end
