defmodule Mix.Tasks.Blog.New do
  use Mix.Task

  @shortdoc "Create a new blog post"

  @moduledoc """
  Create a new blog post, pass in the title of the post as the first argument.
  """

  def run(args) do
    {year, month, day} = Date.utc_today() |> Date.to_iso8601() |> String.split("-")
    title = args |> Enum.at(0)
    slug = title |> String.replace(" ", "-") |> String.downcase()

    contents = """
    ---
    slug: #{slug}
    title: #{title}
    description: 
    tags: []
    ---
    """

    File.write!("lib/jwb/blogs/#{year}-#{month}-#{day}-#{slug}.md", contents)
    Mix.shell().info("✅ Blog post created at lib/jwb/blogs/#{slug}.md")
  end
end
