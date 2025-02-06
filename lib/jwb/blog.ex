defmodule Jwb.Blog do
  @moduledoc """
  Module for working with blog posts.
  """

  alias Jwb.Blogs.Post

  for app <- [:earmark, :makeup_elixir] do
    Application.ensure_all_started(app)
  end

  posts_paths = "lib/jwb/blogs/*.md" |> Path.wildcard() |> Enum.sort()

  posts =
    for post_path <- posts_paths do
      @external_resource Path.relative_to_cwd(post_path)
      Post.parse!(post_path)
    end

  @posts Enum.sort_by(posts, & &1.date, {:desc, Date})

  @spec list_posts() :: [Post.t()]
  def list_posts do
    @posts
  end

  @spec get_post(String.t()) :: Post.t() | nil
  def get_post(slug) do
    case Enum.find(@posts, &(&1.slug == slug)) do
      nil -> {:error, :not_found}
      post -> post
    end
  end
end
