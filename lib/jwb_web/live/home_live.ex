defmodule JwbWeb.HomeLive do
  use JwbWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="prose prose-invert prose-p:text-gray-350 max-w-none mx-auto font-base">
      <p>
        Hey, I'm James!
      </p>
      <p>
        I'm a father, husband, and software engineer. I'm currently working on AI at <a
          class="company-mention text-orange-500 font-medium no-underline"
          href="https://www.zapier.com"
        ><img src={~p"/images/companies/zapier.svg"} width="18" height="18" alt="" /><span>Zapier</span></a>,
        working hard, building cool stuff.
      </p>

      <p>
        Previously, I built the contractor payments platform at <a
          class="company-mention text-blue-500 font-medium no-underline"
          href="https://www.remote.com"
        ><img src={~p"/images/companies/remote.svg"} width="18" height="18" alt="" /><span>Remote</span></a>.
        Before that I built products with a Co-founder, and before <em>that</em>
        I worked as a contractor.
      </p>

      <p>
        This is where I share my <.link
          navigate={~p"/blog"}
          class="text-green-500 font-medium no-underline inline-flex items-center gap-1"
        >
          <.icon name="pen" class="w-3.5 h-3.5" /> learnings</.link>, <.link
          navigate={~p"/projects"}
          class="text-green-500 font-medium no-underline inline-flex items-center gap-1"
        >
          <.icon name="stack" class="w-3.5 h-3.5" /> projects</.link>, and
        <.link
          navigate={~p"/things"}
          class="text-green-500 font-medium no-underline inline-flex items-center gap-1"
        >
          <.icon name="stack" class="w-3.5 h-3.5" /> things
        </.link>
        I like.
      </p>
    </div>
    """
  end
end
