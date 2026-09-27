defmodule JwbWeb.BlogLive do
  use JwbWeb, :live_view

  import JwbWeb.PageIllustration

  alias Jwb.Blogs

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(_, _, %{assigns: %{live_action: :index}} = socket) do
    {:noreply, assign(socket, posts: Blogs.list_posts(), page_title: "Writing")}
  end

  def handle_params(%{"slug" => slug}, _, %{assigns: %{live_action: :show}} = socket) do
    post = Blogs.get_post(slug)
    {:noreply, assign(socket, post: post, page_title: post.title)}
  end

  @impl true
  def render(%{live_action: :index} = assigns) do
    ~H"""
    <div class="writing-page">
      <header class="page-header">
        <.page_illustration name="writing" />
        <h1 class="page-title">Writing</h1>
      </header>
      <div id="writing-index" class="writing-index" phx-hook="WritingHighlight">
        <span class="writing-highlight" aria-hidden="true" inert></span>
        <ul class="writing-list">
          <li :for={post <- @posts}>
            <.link navigate={~p"/blog/#{post.slug}"} class="writing-entry">
              <h2 class="list-title">{post.title}</h2>
              <p class="metadata">
                <time
                  datetime={Date.to_iso8601(post.date)}
                  aria-label={"Published #{Calendar.strftime(post.date, "%B %-d, %Y")}"}
                >
                  {Calendar.strftime(post.date, "%B %-d, %Y")}
                </time>
              </p>
            </.link>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def render(%{live_action: :show} = assigns) do
    ~H"""
    <article class="writing-article">
      <.link navigate={~p"/blog"} class="writing-back">← All writing</.link>
      <header class="page-header writing-header">
        <h1 class="page-title">{@post.title}</h1>
        <p class="metadata">
          Published
          <time datetime={Date.to_iso8601(@post.date)}>
            {Calendar.strftime(@post.date, "%B %-d, %Y")}
          </time>
        </p>
      </header>
      <div class="reading-content prose prose-invert">{raw(@post.body)}</div>
      <footer class="writing-footer">
        <.link navigate={~p"/blog"} class="writing-back">← All writing</.link>
      </footer>
    </article>
    """
  end
end
