defmodule JwbWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component
  use Gettext, backend: JwbWeb.Gettext

  alias Phoenix.LiveView.JS

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                {render_slot(@inner_block)}
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        {@title}
      </p>
      <p class="mt-2 text-sm leading-5">{msg}</p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} title={gettext("Success!")} flash={@flash} />
      <.flash kind={:error} title={gettext("Error!")} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        {gettext("Hang in there while we get back on track")}
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        {render_slot(@inner_block, f)}
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          {render_slot(action, f)}
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information. Unsupported types, such as hidden and radio,
  are best written directly in your templates.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        />
        {@label}
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}>{@label}</.label>
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}>{@label}</.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 min-h-[6rem]",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div>
      <.label for={@id}>{@label}</.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800">
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div class="flex-none">{render_slot(@actions)}</div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id">{user.id}</:col>
        <:col :let={user} label="username">{user.username}</:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal">{col[:label]}</th>
            <th :if={@action != []} class="relative p-0 pb-4">
              <span class="sr-only">{gettext("Actions")}</span>
            </th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-zinc-50">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  {render_slot(col, @row_item.(row))}
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  {render_slot(action, @row_item.(row))}
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title">{@post.title}</:item>
        <:item title="Views">{@post.views}</:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500">{item.title}</dt>
          <dd class="text-zinc-700">{render_slot(item)}</dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      class="text-sm font-semibold leading-6 text-zinc-400 hover:text-zinc-300 no-underline flex items-center"
    >
      <svg
        class="h-4 w-4 mr-2"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          opacity="0.4"
          d="M21 11.9999L15 11.9999"
          stroke="currentColor"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
        <path
          d="M10 5L3 11.9999M3 11.9999L10 18.9999M3 11.9999H15"
          stroke="currentColor"
          stroke-width="1.5"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>

      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Anron icons
  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "home"} = assigns) do
    ~H"""
    <svg
      class={@class}
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      xmlns="http://www.w3.org/2000/svg"
    >
      <g clip-path="url(#clip0_1873_4704)">
        <path
          d="M17.9971 3.83719C15.8568 2.12495 14.7866 1.26882 13.5998 0.940493C12.5529 0.650882 11.4471 0.650882 10.4002 0.940493C9.21339 1.26882 8.14324 2.12495 6.00293 3.83719L4.85293 4.75719C3.52983 5.81567 2.86828 6.34491 2.39209 7.00182C1.97024 7.58377 1.65638 8.23678 1.46548 8.92974C1.25 9.71194 1.25 10.5591 1.25 12.2535V17.5833C1.25 20.4368 3.5632 22.75 6.41667 22.75C7.8434 22.75 9 21.5934 9 20.1667V16C9 14.3431 10.3431 13 12 13C13.6569 13 15 14.3431 15 16V20.1667C15 21.5934 16.1566 22.75 17.5833 22.75C20.4368 22.75 22.75 20.4368 22.75 17.5833V12.2535C22.75 10.5591 22.75 9.71194 22.5345 8.92974C22.3436 8.23678 22.0298 7.58377 21.6079 7.00182C21.1317 6.34491 20.4702 5.81567 19.1471 4.75719L17.9971 3.83719Z"
          fill="currentColor"
        />
      </g>
      <defs>
        <clipPath id="clip0_1873_4704">
          <rect width="24" height="24" fill="white" />
        </clipPath>
      </defs>
    </svg>
    """
  end

  def icon(%{name: "pen"} = assigns) do
    ~H"""
    <svg
      class={@class}
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        d="M19.0001 10.5L18.999 9.5V9.5C18.999 8.41847 18.999 7.87771 18.8863 7.41297C18.5919 6.19917 17.7473 5.19258 16.6032 4.69168C16.1651 4.4999 15.6326 4.40592 14.5675 4.21797L6.50089 2.79445C4.98642 2.52719 4.22919 2.39356 3.68376 2.62504C3.20654 2.82758 2.8266 3.20751 2.62407 3.68474C2.39258 4.23017 2.52621 4.9874 2.79347 6.50187L4.06589 13.7122C4.39767 15.5923 4.56355 16.5323 5.03901 17.2371C5.45818 17.8584 6.04346 18.3494 6.72815 18.6542C7.50481 19 8.45937 19 10.3685 19H11.3481C12.3264 19 12.8156 19 13.276 18.8895C13.6841 18.7915 14.0743 18.6299 14.4322 18.4106C14.8358 18.1632 15.1817 17.8173 15.8735 17.1255L19.499 13.5C20.0513 12.9477 20.9467 12.9477 21.499 13.5V13.5C22.0513 14.0523 22.0513 14.9477 21.499 15.5L15.999 21M3.49951 3.5L7.49997 7.50046M13 11C13 12.1046 12.1046 13 11 13C9.89543 13 9 12.1046 9 11C9 9.89543 9.89543 9 11 9C12.1046 9 13 9.89543 13 11Z"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    """
  end

  def icon(%{name: "pencil"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
      <g clip-path="url(#clip0_1957_4023)">
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M1.79006 5.13232C1.66305 4.41259 1.59955 4.05272 1.67749 3.88266C1.79185 3.63317 2.06092 3.49308 2.33089 3.54247C2.51491 3.57613 2.77331 3.83453 3.2901 4.35132L6.93927 8.00048C7.23216 8.29338 7.70703 8.29338 7.99993 8.00048C8.29282 7.70759 8.29282 7.23272 7.99993 6.93983L4.35129 3.29119C3.83471 2.7746 3.57641 2.51631 3.54272 2.33238C3.49325 2.06231 3.6334 1.79312 3.88302 1.67878C4.05302 1.6009 4.41275 1.66438 5.1322 1.79134L14.4965 3.44388C15.556 3.63083 16.0857 3.72431 16.5296 3.89352C18.1488 4.51066 19.333 5.92216 19.6594 7.62397C19.7489 8.09056 19.7489 8.62847 19.7489 9.70427C19.7489 10.1463 19.7489 10.3673 19.7262 10.5794C19.6445 11.3432 19.3446 12.0673 18.8623 12.6652C18.7284 12.8313 18.5721 12.9876 18.2596 13.3002L13.3004 18.26C12.9876 18.5728 12.8313 18.7292 12.6651 18.8632C12.0673 19.3456 11.3432 19.6455 10.5794 19.7273C10.3671 19.75 10.1459 19.75 9.70365 19.75C8.62738 19.75 8.08925 19.75 7.62246 19.6604C5.92096 19.334 4.50973 18.15 3.89256 16.5311C3.72324 16.087 3.62972 15.5571 3.44268 14.4972L1.79006 5.13232ZM12.9999 11C12.9999 12.1046 12.1044 13 10.9999 13C9.8953 13 8.99987 12.1046 8.99987 11C8.99987 9.89543 9.8953 9 10.9999 9C12.1044 9 12.9999 9.89543 12.9999 11Z"
          fill="currentColor"
        />
        <path
          d="M19.7186 13.2197C20.4257 12.5126 21.5721 12.5126 22.2792 13.2197C22.9863 13.9267 22.9863 15.0732 22.2792 15.7803L15.2792 22.7803C14.5721 23.4874 13.4257 23.4874 12.7186 22.7803C12.0115 22.0732 12.0115 20.9268 12.7186 20.2197L19.7186 13.2197Z"
          fill="currentColor"
        />
      </g>
      <defs>
        <clipPath id="clip0_1957_4023">
          <rect width="24" height="24" fill="white" />
        </clipPath>
      </defs>
    </svg>
    """
  end

  def icon(%{name: "bookmark"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" viewBox="0 0 24 24">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M4.52606 1.90396C5.80953 1.25 7.48969 1.25 10.85 1.25H13.15C16.5103 1.25 18.1905 1.25 19.4739 1.90396C20.6029 2.4792 21.5208 3.39708 22.096 4.52606C22.75 5.80953 22.75 7.48969 22.75 10.85V15.1716C22.75 15.1983 22.75 15.2244 22.75 15.25H19.2H19.1695H19.1695C18.6354 15.25 18.1896 15.25 17.8253 15.2797C17.4454 15.3108 17.0888 15.3779 16.7515 15.5497C16.2341 15.8134 15.8134 16.2341 15.5497 16.7515C15.3779 17.0888 15.3108 17.4454 15.2797 17.8253C15.25 18.1896 15.25 18.6354 15.25 19.1696V19.2V22.75C15.2244 22.75 15.1983 22.75 15.1716 22.75H10.85C7.48968 22.75 5.80953 22.75 4.52606 22.096C3.39708 21.5208 2.4792 20.6029 1.90396 19.4739C1.25 18.1905 1.25 16.5103 1.25 13.15V10.85C1.25 7.48968 1.25 5.80953 1.90396 4.52606C2.4792 3.39708 3.39708 2.4792 4.52606 1.90396ZM16.75 22.6783C17.7964 22.5151 18.7829 22.0775 19.6079 21.4075C19.8487 21.212 20.0759 20.9848 20.5303 20.5304L20.5303 20.5303L20.5304 20.5303C20.9848 20.0759 21.212 19.8487 21.4075 19.6079C22.0775 18.7829 22.5151 17.7964 22.6783 16.75H19.2C18.6276 16.75 18.2434 16.7506 17.9475 16.7748C17.6604 16.7982 17.5231 16.8401 17.4325 16.8862C17.1973 17.0061 17.0061 17.1973 16.8862 17.4325C16.8401 17.5231 16.7982 17.6604 16.7748 17.9475C16.7506 18.2434 16.75 18.6276 16.75 19.2V22.6783Z"
        fill="currentColor"
      />
    </svg>
    """
  end

  def icon(%{name: "stack"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="1.5"
        d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
      />
    </svg>
    """
  end

  def icon(%{name: "kept"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" viewBox="0 0 24 24">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M8.8352 5.25755C9.17104 3.8204 10.4605 2.75 12 2.75C13.5395 2.75 14.829 3.8204 15.1648 5.25755C14.6613 5.25 14.086 5.25 13.4178 5.25H10.5823C9.91406 5.25 9.33873 5.25 8.8352 5.25755ZM7.29685 5.33032C7.62228 3.02407 9.60397 1.25 12 1.25C14.3961 1.25 16.3777 3.02407 16.7032 5.33032C17.2085 5.38135 17.623 5.46481 18.0041 5.60129C19.556 6.15705 20.8109 7.3268 21.4741 8.83589C21.8933 9.78978 21.9776 10.9886 22.1462 13.3863C22.3376 16.1074 22.4332 17.468 22.0894 18.5567C21.5451 20.2804 20.2528 21.6669 18.5715 22.3307C17.5096 22.75 16.1456 22.75 13.4178 22.75H10.5823C7.85439 22.75 6.49045 22.75 5.42856 22.3307C3.74729 21.6669 2.4549 20.2804 1.9106 18.5567C1.56682 17.468 1.66249 16.1074 1.85382 13.3863C2.02241 10.9886 2.1067 9.78978 2.52593 8.83589C3.18917 7.3268 4.44406 6.15705 5.99594 5.60129C6.37706 5.46481 6.79152 5.38135 7.29685 5.33032ZM8 11C8.55228 11 9 10.5523 9 10C9 9.44771 8.55228 9 8 9C7.44772 9 7 9.44771 7 10C7 10.5523 7.44772 11 8 11ZM17 10C17 10.5523 16.5523 11 16 11C15.4477 11 15 10.5523 15 10C15 9.44771 15.4477 9 16 9C16.5523 9 17 9.44771 17 10Z"
        fill="currentColor"
      />
    </svg>
    """
  end

  def icon(%{name: "stfu"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" viewBox="0 0 24 24">
      <path
        d="M8.04946 1.75442C11.7066 0.70665 16.0159 1.72939 18.3562 5.64338C18.5001 5.88413 18.4977 6.18509 18.3499 6.42349C18.202 6.66189 17.9335 6.79787 17.6539 6.77597C12.9375 6.40661 8.75 10.2563 8.75 15.0005C8.75 16.2629 9.03304 17.4571 9.53842 18.525C9.65989 18.7817 9.62599 19.0849 9.45083 19.3084C9.27567 19.532 8.9893 19.6374 8.71103 19.5808C8.35395 19.5082 8.01079 19.4122 7.67722 19.2929C7.29751 19.157 6.91626 18.9942 6.525 18.8928C6.10656 18.7944 5.83146 18.8743 5.48304 19.0399C5.15299 19.1968 4.5761 19.5531 3.88246 19.6686C2.85435 19.8399 1.93956 18.9982 2.02488 17.9594C2.07229 17.3822 2.40428 16.9464 2.55804 16.4114C2.74338 15.7665 2.52822 15.302 2.11145 14.4024L2.10266 14.3834C1.5553 13.2018 1.25 11.8858 1.25 10.5005C1.25 5.95571 4.39451 2.80157 8.04946 1.75442Z"
        fill="currentColor"
      />
      <path
        d="M10.25 15.0003C10.25 11.2724 13.2721 8.25032 17 8.25032C20.7279 8.25032 23.75 11.2724 23.75 15.0003C23.75 16.0109 23.5272 16.9715 23.1277 17.8339C22.8219 18.4941 22.7129 18.7457 22.8181 19.1118C22.9308 19.504 23.1673 19.8218 23.2023 20.2474C23.2743 21.1239 22.5024 21.8341 21.635 21.6896C21.1048 21.6012 20.6491 21.3236 20.4467 21.2274C20.226 21.1225 20.0851 21.0853 19.8565 21.139C19.5891 21.2147 19.3282 21.3209 19.0668 21.4144C18.4313 21.6418 17.7583 21.7503 17 21.7503C13.2721 21.7503 10.25 18.7282 10.25 15.0003Z"
        fill="currentColor"
      />
    </svg>
    """
  end

  def icon(%{name: "mmentum"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" viewBox="0 0 16 24">
      <path
        d="M8 0.25C4.39609 0.25 2.59414 0.25 1.74423 0.77977C0.37436 1.63364 -0.233876 3.31362 0.271852 4.84655C0.585621 5.79763 1.96992 6.95121 4.73852 9.25838L5.40399 9.81294C5.86376 10.1961 6.09363 10.3876 6.18809 10.612C6.29253 10.8601 6.29253 11.1399 6.18809 11.388C6.09363 11.6124 5.86376 11.8039 5.40399 12.1871L4.73852 12.7416C1.96992 15.0488 0.585621 16.2024 0.271852 17.1535C-0.233876 18.6864 0.37436 20.3664 1.74423 21.2202C2.59414 21.75 4.3961 21.75 8 21.75C11.6039 21.75 13.4059 21.75 14.2558 21.2202C15.6256 20.3664 16.2339 18.6864 15.7282 17.1535C15.4144 16.2024 14.0301 15.0488 11.2615 12.7416L10.596 12.1871C10.1363 11.8039 9.90637 11.6124 9.81192 11.388C9.70748 11.1399 9.70748 10.8601 9.81192 10.612C9.90637 10.3876 10.1363 10.1961 10.596 9.81294L11.2615 9.25838C14.0301 6.95121 15.4144 5.79763 15.7282 4.84655C16.2339 3.31362 15.6256 1.63364 14.2558 0.77977C13.4059 0.25 11.6039 0.25 8 0.25Z"
        fill="currentColor"
      />
    </svg>
    """
  end

  def icon(%{name: "space"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" viewBox="0 0 24 24">
      <g clip-path="url(#clip0_1873_4738)">
        <path
          d="M3.16391 20.5775C2.50789 20.7087 2.17988 20.7743 1.92318 20.6855C1.69803 20.6076 1.50808 20.4519 1.38755 20.2464C1.25012 20.0121 1.25012 19.6776 1.25012 19.0086L1.25012 16.7574C1.25012 15.7331 1.25012 15.221 1.3667 14.7487C1.51956 14.1295 1.81825 13.5559 2.23786 13.0756C2.55791 12.7093 2.97749 12.4156 3.81666 11.8283C4.15811 11.5893 4.32884 11.4698 4.46963 11.4612C4.65409 11.45 4.82971 11.5414 4.92629 11.699C5 11.8192 5 12.0276 5 12.4444V19.5544C5 19.7881 5 19.9049 4.95816 20.0006C4.92126 20.085 4.86175 20.1576 4.78619 20.2104C4.70052 20.2702 4.58598 20.2931 4.35689 20.3389L3.16391 20.5775Z"
          fill="currentColor"
        />
        <path
          d="M20.1834 11.8282C21.0226 12.4156 21.4423 12.7093 21.7624 13.0757C22.182 13.5559 22.4807 14.1296 22.6335 14.7487C22.7501 15.221 22.7501 15.7332 22.7501 16.7576V19.0086C22.7501 19.6776 22.7501 20.0121 22.6127 20.2464C22.4922 20.4519 22.3022 20.6076 22.0771 20.6855C21.8204 20.7743 21.4924 20.7087 20.8363 20.5775L19.6431 20.3389C19.414 20.293 19.2995 20.2701 19.2138 20.2103C19.1383 20.1576 19.0787 20.085 19.0418 20.0006C19 19.9048 19 19.788 19 19.5544V12.4444C19 12.0276 19 11.8192 19.0737 11.6989C19.1703 11.5414 19.3459 11.45 19.5303 11.4612C19.6711 11.4697 19.8419 11.5892 20.1834 11.8282Z"
          fill="currentColor"
        />
        <path
          fill-rule="evenodd"
          clip-rule="evenodd"
          d="M8.03305 3.95955C9.42116 2.56638 10.1152 1.86979 10.9161 1.60893C11.6206 1.37948 12.3797 1.37949 13.0841 1.60895C13.885 1.86983 14.579 2.56643 15.9671 3.95963L16.1338 4.12692C16.8226 4.81825 17.167 5.16392 17.4132 5.56695C17.6316 5.92427 17.7925 6.31367 17.89 6.72091C18 7.18023 18 7.66818 18 8.64408V9.62467V18.5502C18 18.7359 18 18.8287 17.9969 18.9072C17.915 20.993 16.2429 22.6651 14.157 22.7471C14.0786 22.7502 13.9857 22.7502 13.8 22.7502H13.5C13.0858 22.7502 12.75 22.4144 12.75 22.0001V19.75C12.75 19.3358 12.4142 19 12 19C11.5858 19 11.25 19.3358 11.25 19.75V22.0001C11.25 22.4144 10.9142 22.7502 10.5 22.7502H10.2C10.0143 22.7502 9.92145 22.7502 9.84296 22.7471C7.75714 22.6651 6.08504 20.993 6.00308 18.9072C6 18.8287 6 18.7359 6 18.5502L6 8.64416C6 7.66823 6 7.18027 6.11001 6.72094C6.20755 6.31369 6.36843 5.92428 6.58678 5.56694C6.83306 5.16391 7.17747 4.81824 7.8663 4.1269L8.03305 3.95955ZM12 11C13.1046 11 14 10.1046 14 9C14 7.89543 13.1046 7 12 7C10.8954 7 10 7.89543 10 9C10 10.1046 10.8954 11 12 11Z"
          fill="currentColor"
        />
      </g>
      <defs>
        <clipPath id="clip0_1873_4738">
          <rect width="24" height="24" fill="white" />
        </clipPath>
      </defs>
    </svg>
    """
  end

  def icon(%{name: "flowist"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" viewBox="0 0 24 24">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M15.325 5.75024L11 5.75024C9.00129 5.75024 7.26342 6.86718 6.37655 8.51093C7.76658 9.05974 8.75003 10.4151 8.75003 12.0002C8.75003 13.5853 7.76657 14.9407 6.37655 15.4895C7.26342 17.1333 9.00128 18.2502 11 18.2502L15.325 18.2502C15.6725 16.5386 17.1858 15.2502 19 15.2502C21.0711 15.2502 22.75 16.9292 22.75 19.0002C22.75 21.0713 21.0711 22.7502 19 22.7502C17.1858 22.7502 15.6725 21.4619 15.325 19.7502L11 19.7502C8.25005 19.7502 5.88417 18.1058 4.83213 15.7465C2.83898 15.6587 1.25003 14.015 1.25003 12.0002C1.25003 9.98543 2.83898 8.34175 4.83213 8.25392C5.88418 5.89472 8.25006 4.25024 11 4.25024L15.325 4.25024C15.6725 2.53856 17.1858 1.25023 19 1.25023C21.0711 1.25023 22.75 2.92917 22.75 5.00023C22.75 7.0713 21.0711 8.75023 19 8.75023C17.1858 8.75023 15.6725 7.46192 15.325 5.75024Z"
        fill="currentColor"
      />
    </svg>
    """
  end

  def icon(%{name: "rize"} = assigns) do
    ~H"""
    <svg class={@class} width="14" height="14" fill="none" viewBox="0 0 24 24">
      <path
        opacity="0.4"
        d="M12 15V21"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
      <path
        d="M12 15V3M12 3L19 10M12 3L5 10"
        stroke="currentColor"
        stroke-width="1.5"
        stroke-linecap="round"
        stroke-linejoin="round"
      />
    </svg>
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(JwbWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(JwbWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
