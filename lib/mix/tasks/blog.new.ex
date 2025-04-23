defmodule Mix.Tasks.Blog.New do
  @moduledoc """
  Create a new blog post, pass in the title of the post as the first argument.
  """
  @shortdoc "Create a new blog post"
  use Mix.Task

  def run([title]) do
    {year, month, day} = Date.utc_today() |> Date.to_iso8601() |> String.split("-")
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
  end

  def run(_) do
    Mix.shell().error("Please pass in a title for the blog post")
  end
end
