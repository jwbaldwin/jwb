defmodule JwbWeb.SidebarComponent do
  use Phoenix.Component

  attr :current_url, :string, required: true

  def sidebar(assigns) do
    ~H"""
    <div class="fixed left-0 top-0 h-full w-[240px] border-r border-[#1C1C1E] bg-[#161618] p-5">
      <div class="mb-8 px-3">
        <h1 class="text-base font-medium text-white">James Baldwin</h1>
      </div>

      <nav class="space-y-1">
        <.nav_item current_url={@current_url} path="/" icon="home" label="Home" />
        <.nav_item current_url={@current_url} path="/writing" icon="pencil" label="Writing" />

        <div class="pt-8">
          <p class="px-3 pb-2 text-xs font-medium text-gray-500 uppercase">Me</p>
          <.nav_item current_url={@current_url} path="/bookmarks" icon="bookmark" label="Bookmarks" />
          <.nav_item current_url={@current_url} path="/stack" icon="stack" label="Stack" />
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
        "flex items-center gap-2 rounded-md px-3 py-2 transition-colors duration-200",
        if(@current_url.path == @path,
          do: "bg-[#323234] text-white",
          else: "text-[#A1A1A6] hover:bg-[#1C1C1E]"
        )
      ]}
    >
      <.icon name={@icon} class="h-[18px] w-[18px]" />
      <span>{@label}</span>
    </.link>
    """
  end

  # Add any custom icons you need here
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "home"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="1.5"
        d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
      />
    </svg>
    """
  end

  def icon(%{name: "pencil"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="1.5"
        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
      />
    </svg>
    """
  end

  def icon(%{name: "bookmark"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="1.5"
        d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z"
      />
    </svg>
    """
  end

  def icon(%{name: "stack"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="1.5"
        d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
      />
    </svg>
    """
  end
end
