defmodule JwbWeb.HomeLive do
  use JwbWeb, :live_view

  import JwbWeb.NavigationIcon, only: [navigation_icon: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="prose prose-invert prose-p:text-gray-350 max-w-none mx-auto font-base">
      <h1 class="home-greeting">
        Hey, I'm James!
      </h1>
      <p>
        I'm a father, husband, and software engineer. I'm currently working on AI at <a
          class="company-mention text-orange-500 font-medium no-underline"
          href="https://www.zapier.com"
        ><img src={~p"/images/companies/zapier.svg"} width="18" height="18" alt="" /><span>Zapier</span></a>.
      </p>

      <p>
        Previously, I built the contractor payments platform at <a
          class="company-mention text-blue-500 font-medium no-underline"
          href="https://www.remote.com"
        ><img src={~p"/images/companies/remote.svg"} width="18" height="18" alt="" /><span>Remote</span></a>.
      </p>

      <p>
        This is where I share my <.link
          navigate={~p"/blog"}
          class="navigation-link navigation-link--inline text-green-500 font-medium no-underline"
        >
          <.navigation_icon name="writing" /><span class="navigation-label">learnings</span></.link>, <.link
          navigate={~p"/projects"}
          class="navigation-link navigation-link--inline text-green-500 font-medium no-underline"
        >
          <.navigation_icon name="projects" /><span class="navigation-label">projects</span></.link>, and
        <.link
          navigate={~p"/things"}
          class="navigation-link navigation-link--inline text-green-500 font-medium no-underline"
        >
          <.navigation_icon name="things" /><span class="navigation-label">things</span>
        </.link>
        I like.
      </p>
    </div>
    """
  end
end
