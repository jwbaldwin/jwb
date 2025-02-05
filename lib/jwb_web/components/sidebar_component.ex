defmodule JwbWeb.SidebarComponent do
  use Phoenix.Component
  import JwbWeb.CoreComponents, only: [icon: 1]

  attr :current_url, :string, required: true

  def sidebar(assigns) do
    ~H"""
    <div class="fixed inset-0 h-full w-[240px] border-r border-[#2C2C2E] bg-[#161618] p-5">
      <div class="mb-8 px-3">
        <h1 class="text-base font-medium text-white">James Baldwin</h1>
      </div>

      <nav class="space-y-1">
        <.nav_item current_url={@current_url} path="/" icon="home" label="Home" />
        <.nav_item current_url={@current_url} path="/blog" icon="pencil" label="Writing" />

        <div class="pt-8">
          <p class="px-3 pb-2 text-xs font-medium text-gray-500">Projects</p>
          <.nav_item current_url={@current_url} path="/projects/kept" icon="kept" label="Kept" />
          <.nav_item current_url={@current_url} path="/projects/stfu" icon="stfu" label="STFU.ai" />
          <.nav_item
            current_url={@current_url}
            path="/projects/mmentum"
            icon="mmentum"
            label="Mmentum"
          />
          <.nav_item
            current_url={@current_url}
            path="/projects/space"
            icon="space"
            label="Space Invaders"
          />
          <.nav_item
            current_url={@current_url}
            path="/projects/flowist"
            icon="flowist"
            label="Flowist"
          />
          <.nav_item current_url={@current_url} path="/projects/rize" icon="rize" label="Rize" />
        </div>
        <div class="pt-8">
          <p class="px-3 pb-2 text-xs font-medium text-gray-500">Misc</p>
          <.nav_item current_url={@current_url} path="/bookmarks" icon="bookmark" label="Bookmarks" />
          <.nav_item current_url={@current_url} path="/things" icon="stack" label="Stack" />
        </div>
      </nav>
    </div>
    """
  end

  attr :current_url, :string, required: true
  attr :path, :string, required: true
  attr :icon, :string, required: true
  attr :label, :string, required: true

  def nav_item(assigns) do
    ~H"""
    <.link
      navigate={@path}
      class={[
        "flex items-center gap-2 rounded-md smooth-corners-sm px-3 py-2 transition-colors duration-200",
        if(@current_url.path == @path,
          do: "bg-[#323234] text-white",
          else: "text-[#A1A1A6] hover:bg-[#1C1C1E]"
        )
      ]}
    >
      <.icon name={@icon} class="w-3.5 h-3.5" />
      <span>{@label}</span>
    </.link>
    """
  end
end
