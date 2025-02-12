defmodule JwbWeb.SidebarComponent do
  use Phoenix.Component

  import JwbWeb.CoreComponents, only: [icon: 1]

  alias Phoenix.LiveView.JS

  attr :current_url, :string, required: true

  def sidebar(assigns) do
    assigns = assign_new(assigns, :show_mobile_menu, fn -> false end)

    ~H"""
    <div class="md:hidden fixed top-4 left-8 sm:left-20 z-50">
      <button
        id="mobile-button"
        type="button"
        class="text-gray-200 hover:text-white"
        phx-click={toggle_mobile_menu()}
      >
        <svg
          class="w-5 h-5 text-white hover:text-gray-200"
          viewBox="0 0 24 24"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            d="M3 6H21M3 12H21M3 18H21"
            stroke="currentColor"
            stroke-width="1.5"
            stroke-linecap="round"
          />
        </svg>
      </button>
    </div>
    <div
      id="mobile-backdrop"
      class="hidden md:hidden fixed inset-0 bg-black/50 backdrop-blur-sm z-40"
      phx-click={toggle_mobile_menu()}
    >
    </div>
    <div
      id="mobile-menu"
      class={[
        "fixed inset-y-0 left-0 z-40 w-2/3 mx-4 my-4 md:w-[240px] md:translate-x-0 md:flex hidden",
        "border border-[#2C2C2E] rounded-lg md:border-r bg-[#161618] p-5 flex-col justify-between"
      ]}
    >
      <div class="mb-8 px-3 flex justify-between items-center">
        <h1 class="text-base font-medium text-white">James Baldwin</h1>
        <button
          type="button"
          class="md:hidden text-gray-200 hover:text-white"
          phx-click={toggle_mobile_menu()}
        >
          <svg
            class="w-5 h-5 text-white hover:text-gray-200"
            viewBox="0 0 24 24"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              d="M6 18L12 12M18 6L14 10M6 6L12 12M18 18L12 12"
              stroke="currentColor"
              stroke-width="1.5"
              stroke-linecap="round"
              stroke-linejoin="round"
            />
          </svg>
        </button>
      </div>

      <nav class="space-y-1 flex-1">
        <.nav_item current_url={@current_url} path="/" icon="home" label="Home" />
        <.nav_item current_url={@current_url} path="/blog" icon="pencil" label="Writing" />

        <div class="pt-8 group">
          <p class="px-3 pb-2 text-xs font-medium text-gray-500 group-hover:text-gray-400 transition duration-200">
            Projects
          </p>
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
            path="/projects/sphxace-invaders"
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
        <div class="pt-8 group">
          <p class="px-3 pb-2 text-xs font-medium text-gray-500 group-hover:text-gray-400 transition duration-200">
            Collections
          </p>
          <!-- <.nav_item current_url={@current_url} path="/bookmarks" icon="bookmark" label="Bookmarks" /> -->
          <.nav_item current_url={@current_url} path="/things" icon="stack" label="Things" />
        </div>
      </nav>
      <div class="bottom-0 flex w-full justify-center pb-4 gap-2 pt-4">
        <a href="https://x.com/jwbaldwin" class="text-zinc-500">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M16.67 2.25C13.7029 2.25 11.2721 4.61002 11.2721 7.55422C11.2721 7.62338 11.2736 7.69247 11.2766 7.7615C8.00936 7.34208 5.10976 5.69957 3.12289 3.3409C2.96761 3.15657 2.7332 3.05809 2.49286 3.07622C2.25252 3.09435 2.03554 3.22689 1.90967 3.43244C0.927355 5.03663 0.97664 7.00898 1.82032 8.58535C1.43999 8.61839 1.1353 8.94804 1.1353 9.33253C1.1353 10.9216 1.85114 12.3874 3.01053 13.3826C2.80405 13.576 2.72158 13.8826 2.80796 14.156C3.28249 15.6582 4.41851 16.8469 5.86664 17.4381C4.39259 18.1382 2.73498 18.4183 1.09116 18.217C0.743559 18.1744 0.412761 18.3781 0.294242 18.7076C0.175722 19.0372 0.301034 19.4049 0.59613 19.5934C2.75448 20.9727 5.32952 21.75 8.12675 21.75C17.1536 21.75 22.1077 14.4448 22.1077 8.0747V7.59031L22.1269 7.57245C22.3186 7.39301 22.5637 7.12628 22.8053 6.7591C23.2931 6.01801 23.75 4.89264 23.75 3.30361C23.75 3.03461 23.6059 2.78621 23.3724 2.65262C23.1389 2.51904 22.8518 2.52074 22.6199 2.65707C21.9156 3.07112 21.1148 3.39793 20.301 3.60844C19.3141 2.73976 18.0501 2.25 16.67 2.25Z"
              fill="currentColor"
            />
          </svg>
        </a>
        <a href="https://github.com/jwbaldwin" class="text-zinc-500">
          <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M14.5094 20.9056C14.5198 20.402 14.5349 19.6585 14.5349 19C14.5349 18 13.8548 17.0818 13.8548 17.0818C16.1129 16.834 18.4919 15.5037 18.4919 11.5393C18.4919 10.383 18.0887 9.84616 17.4435 9.10284L17.4579 9.0525C17.5588 8.7032 17.8583 7.66631 17.3226 6.29474C16.4758 6.00567 14.5403 7.40972 14.5403 7.40972C13.7339 7.16195 12.8871 7.07936 12 7.07936C11.1532 7.07936 10.3065 7.16195 9.5 7.40972C9.5 7.40972 7.52419 6.04697 6.71774 6.29474C6.15323 7.74009 6.47581 8.81377 6.59677 9.10284C5.95161 9.84616 5.62903 10.383 5.62903 11.5393C5.62903 15.5037 7.92742 16.834 10.1855 17.0818C10.1855 17.0818 9.5 17.8624 9.5 18.9312V20.9082V22.4578C4.76861 21.3309 1.25 17.0764 1.25 12C1.25 6.06294 6.06294 1.25 12 1.25C17.9371 1.25 22.75 6.06294 22.75 12C22.75 17.073 19.2361 21.3252 14.5094 22.4555V20.9056Z"
              fill="currentColor"
            />
          </svg>
        </a>
      </div>
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
      id={@label}
      class={[
        "flex items-center gap-2 rounded-md px-3 py-2 transition-colors duration-200 group/link",
        if(@current_url.path == @path,
          do: "bg-[#323234] text-white",
          else: "text-[#A1A1A6] hover:bg-[#A1A1A6]/10"
        )
      ]}
    >
      <.icon name={@icon} class="w-3.5 h-3.5" />
      <span>{@label}</span>
    </.link>
    """
  end

  def toggle_mobile_menu(js \\ %JS{}) do
    js
    |> JS.toggle(
      to: "#mobile-menu",
      in: {"transition-transform ease-in-out duration-300", "-translate-x-full", "translate-x-0"},
      out: {"transition-transform ease-in-out duration-300", "translate-x-0", "-translate-x-full"}
    )
    |> JS.toggle(
      to: "#mobile-backdrop",
      in: {"transition-opacity ease-in-out duration-300", "opacity-0", "opacity-100"},
      out: {"transition-opacity ease-in-out duration-300", "opacity-100", "opacity-0"}
    )
    |> JS.toggle(
      to: "#mobile-button",
      in: {"transition-opacity ease-in-out duration-300", "opacity-0", "opacity-100"},
      out: {"transition-opacity ease-in-out duration-50", "opacity-100", "opacity-0"}
    )
  end
end
