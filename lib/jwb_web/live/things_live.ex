defmodule JwbWeb.ThingsLive do
  use JwbWeb, :live_view

  import JwbWeb.PageIllustration

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       workspace_items: [
         %{
           name: "Moonlander",
           description:
             "I love my Moonlander. My first split keyboard. I've installed black ink switches which I lubed myself.",
           image: "/images/things/moonlander.png",
           url: "https://www.zsa.io/moonlander"
         },
         %{
           name: "Cyboard Imprint",
           description:
             "A made-to-measure ergonomic keyboard with a built-in trackball. Added HMX Cheese switches. Feels incredible and a joy to type on.",
           image: "/images/things/cyboard_imprint.webp",
           photo: true,
           url: "https://cyboard.digital/products/imprint"
         },
         %{
           name: "Grovemade Headphone Stand",
           description:
             "Walnut all the things! It's a truly beautiful piece of desk decor. I enjoy the craft that clearly went into it. Though I wish it never collected dust.",
           image: "/images/things/headphone_stand.webp",
           photo: true
         }
       ],
       edc_items: [
         %{
           name: "Apple Watch Ultra",
           description:
             "I wasn't much of a watch user for a few reasons. But once I had my son, I realized I really needed a way to avoid being on my phone.",
           image: "/images/things/apple_watch_ultra.webp"
         },
         %{
           name: "Spyderco PM3",
           description:
             "With the number of boxes I open, it's extremely handy to have a lightweight knife on me at all times.",
           image: "/images/things/knife.webp"
         }
       ]
     )}
  end

  @impl true
  def handle_params(_, _, %{assigns: %{live_action: :index}} = socket) do
    {:noreply, assign(socket, page_title: "My things")}
  end

  @impl true
  def render(%{live_action: :index} = assigns) do
    ~H"""
    <div class="things-page" id="things-gallery" phx-hook="ThingDetails">
      <header class="page-header">
        <.page_illustration name="things" />
        <h1 class="page-title">My things</h1>
        <p class="page-intro">
          These are items I own or use regularly either for my workspace or my everyday. I'll update this page anytime I find an item I feel is worth mentioning.
        </p>
      </header>
      <section
        :for={{heading, items} <- [{"Workspace", @workspace_items}, {"Everyday carry", @edc_items}]}
        class="things-section"
      >
        <h2 class="things-section-title">{heading}</h2>
        <ul class="things-list">
          <li :for={item <- items}>
            <button
              type="button"
              class="thing-tile"
              data-thing-open={item.name}
              aria-haspopup="dialog"
            >
              <span class={["thing-image", Map.get(item, :photo, false) && "thing-photo"]}>
                <img src={item.image} alt="" loading="lazy" decoding="async" />
              </span>
              <span class="list-title">{item.name}</span>
            </button>
            <dialog class="thing-dialog" data-thing-dialog={item.name} aria-label={item.name}>
              <div class="thing-dialog-toolbar">
                <button
                  type="button"
                  class="thing-close"
                  aria-label="Close details"
                  data-thing-close
                  autofocus
                >
                  <span aria-hidden="true">×</span>
                </button>
              </div>
              <div class={[
                "thing-image",
                "thing-detail-image",
                Map.get(item, :photo, false) && "thing-photo"
              ]}>
                <img src={item.image} alt={item.name} loading="eager" decoding="sync" />
              </div>
              <div class="thing-copy">
                <h2 class="thing-detail-title">{item.name}</h2>
                <p>{item.description}</p>
                <a :if={Map.get(item, :url)} href={Map.get(item, :url)} class="thing-link">
                  View {item.name} <span aria-hidden="true">↗</span>
                </a>
              </div>
            </dialog>
          </li>
        </ul>
      </section>
    </div>
    """
  end
end
