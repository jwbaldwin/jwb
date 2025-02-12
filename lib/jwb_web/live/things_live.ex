defmodule JwbWeb.ThingsLive do
  use JwbWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       workspace_items: [
         %{
           name: "Moonlander",
           description:
             "I love my Moonlander. My first split keyboard. I've installed black ink switches which I lubed myself.",
           image: "/images/things/moonlander.png"
         },
         %{
           name: "Grovemade Headphone stand",
           description:
             "Walnut all the things! It's a truly beautiful piece of desk decor. I enjoy the craft that clearly went into it. Though I wish it never collected dust.",
           image: "/images/things/headphone_stand.jpeg"
         }
       ],
       edc_items: [
         %{
           name: "Apple Watch Ultra",
           description:
             "I wasn't much of a watch user for a few reasions. But once I had my son, I realized I really needed a way to avoid being on my phone.",
           image: "/images/things/apple_watch_ultra.jpeg"
         },
         %{
           name: "Spyderco PM3",
           description:
             "With the amount of boxes I open, it's extremely handy to have a lightweight knife on me at all times.",
           image: "/images/things/knife.jpeg"
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
    <div class="max-w-4xl px-4 mx-auto">
      <h1 class="text-3xl font-bold">My things</h1>
      <p class="text-gray-400 text-sm pt-2">
        These are items I own or use regularly either for my workspace or my everyday. I'll update this page anytime I find an item I feel is worth mentioning.
      </p>
      <div class="space-y-12 pt-12">
        <section>
          <h2 class="text-xl font-bold mb-6">Workspace</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <%= for item <- @workspace_items do %>
              <div class="bg-[#1C1C1E] rounded-lg overflow-hidden">
                <div class="aspect-w-16 aspect-h-9">
                  <img src={item.image} alt={item.name} class="object-contain w-full h-40 bg-white" />
                </div>
                <div class="p-4">
                  <h3 class="text-lg font-semibold mb-2">{item.name}</h3>
                  <p class="text-gray-500 text-sm">{item.description}</p>
                </div>
              </div>
            <% end %>
          </div>
        </section>

        <section>
          <h2 class="text-xl font-bold mb-6">EDC</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <%= for item <- @edc_items do %>
              <div class="bg-[#1C1C1E] rounded-lg overflow-hidden">
                <div class="aspect-w-16 aspect-h-9">
                  <img src={item.image} alt={item.name} class="object-contain w-full h-40 bg-white" />
                </div>
                <div class="p-4">
                  <h3 class="text-lg font-semibold mb-2">{item.name}</h3>
                  <p class="text-gray-500 text-sm">{item.description}</p>
                </div>
              </div>
            <% end %>
          </div>
        </section>
      </div>
    </div>
    """
  end
end
