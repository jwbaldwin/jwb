defmodule JwbWeb.HomeLive do
  use JwbWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="prose prose-invert prose-p:text-gray-300 max-w-none mx-auto font-base">
      <p>
        I'm James Baldwin, a father, husband, and software engineer. I'm currently working at <a
          class="text-blue-500 font-medium no-underline"
          href="https://www.remote.com"
        >Remote</a>, which makes for a fun verbal mix-up each time I tell someone. I build the contractor payments platform.
      </p>

      <p>
        Previously I've built products with a Co-founder, and before that I worked as a contractor.
      </p>

      <p>
        This is where I share my <.link
          navigate={~p"/blog"}
          class="text-green-500 font-medium no-underline inline-flex items-center gap-1"
        >
          <.icon name="pen" class="w-3.5 h-3.5" /> learnings</.link>, <.link
          navigate={~p"/projects/rize"}
          class="text-green-500 font-medium no-underline inline-flex items-center gap-1"
        >
          <.icon name="rize" class="w-3.5 h-3.5" /> projects</.link>, and
        <.link
          navigate={~p"/things"}
          class="text-green-500 font-medium no-underline inline-flex items-center gap-1"
        >
          <.icon name="stack" class="w-3.5 h-3.5" /> my things
        </.link>
        I'm excited about.
      </p>
    </div>
    """
  end
end
