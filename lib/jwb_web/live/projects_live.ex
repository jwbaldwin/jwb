defmodule JwbWeb.ProjectsLive do
  use JwbWeb, :live_view

  alias Jwb.Projects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"slug" => slug}, _, %{assigns: %{live_action: :show}} = socket) do
    project = Projects.get_project(slug)

    {:noreply, assign(socket, project: project, page_title: project.name)}
  end

  @impl true
  def render(%{live_action: :show} = assigns) do
    ~H"""
    <div class="max-w-4xl px-4 mx-auto">
      <div class="flex items-center justify-center">
        <%= if @project == {:error, :not_found} do %>
          <pre><code>{raw("{:error, :oops_404}")}</code></pre>
        <% else %>
          <article class="prose prose-invert">
            <div class="flex justify-between items-center mb-8 gap-8">
              <img class="w-20" src={@project.cover} />
              <div class="flex-1">
                <h1 class="text-2xl font-bold mb-2 text-zinc-100">{@project.name}</h1>
                <div class="text-zinc-400 text-sm">{@project.description}</div>
              </div>
              <div class="px-4 py-2 bg-zinc-800 rounded-lg text-zinc-400 text-sm">
                {@project.category}
              </div>
            </div>
            {raw(@project.body)}
            <%= for gallery <- @project.gallery do %>
              <img src={gallery} />
            <% end %>
          </article>
        <% end %>
      </div>
    </div>
    """
  end
end
