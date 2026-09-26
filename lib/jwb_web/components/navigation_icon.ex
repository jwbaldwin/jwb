defmodule JwbWeb.NavigationIcon do
  use Phoenix.Component

  attr :name, :string, required: true, values: ~w(home writing projects things)

  def navigation_icon(assigns) do
    ~H"""
    <svg
      class="navigation-icon"
      data-navigation-icon={@name}
      width="16"
      height="16"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="1.5"
      stroke-linecap="round"
      stroke-linejoin="round"
      aria-hidden="true"
      focusable="false"
      xmlns="http://www.w3.org/2000/svg"
    >
      <%= case @name do %>
        <% "home" -> %>
          <path
            fill="currentColor"
            stroke-width="1"
            d="M17.9971 3.83719C15.8568 2.12495 14.7866 1.26882 13.5998 0.940493C12.5529 0.650882 11.4471 0.650882 10.4002 0.940493C9.21339 1.26882 8.14324 2.12495 6.00293 3.83719L4.85293 4.75719C3.52983 5.81567 2.86828 6.34491 2.39209 7.00182C1.97024 7.58377 1.65638 8.23678 1.46548 8.92974C1.25 9.71194 1.25 10.5591 1.25 12.2535V17.5833C1.25 20.4368 3.5632 22.75 6.41667 22.75C7.8434 22.75 9 21.5934 9 20.1667V16C9 14.3431 10.3431 13 12 13C13.6569 13 15 14.3431 15 16V20.1667C15 21.5934 16.1566 22.75 17.5833 22.75C20.4368 22.75 22.75 20.4368 22.75 17.5833V12.2535C22.75 10.5591 22.75 9.71194 22.5345 8.92974C22.3436 8.23678 22.0298 7.58377 21.6079 7.00182C21.1317 6.34491 20.4702 5.81567 19.1471 4.75719L17.9971 3.83719Z"
          />
        <% "writing" -> %>
          <path class="navigation-ink" pathLength="1" d="M2 2Q3 2 3.5 3L4.5 4" />
          <path
            class="navigation-pen"
            d="M19.0001 10.5L18.999 9.5V9.5C18.999 8.41847 18.999 7.87771 18.8863 7.41297C18.5919 6.19917 17.7473 5.19258 16.6032 4.69168C16.1651 4.4999 15.6326 4.40592 14.5675 4.21797L6.50089 2.79445C4.98642 2.52719 4.22919 2.39356 3.68376 2.62504C3.20654 2.82758 2.8266 3.20751 2.62407 3.68474C2.39258 4.23017 2.52621 4.9874 2.79347 6.50187L4.06589 13.7122C4.39767 15.5923 4.56355 16.5323 5.03901 17.2371C5.45818 17.8584 6.04346 18.3494 6.72815 18.6542C7.50481 19 8.45937 19 10.3685 19H11.3481C12.3264 19 12.8156 19 13.276 18.8895C13.6841 18.7915 14.0743 18.6299 14.4322 18.4106C14.8358 18.1632 15.1817 17.8173 15.8735 17.1255L19.499 13.5C20.0513 12.9477 20.9467 12.9477 21.499 13.5V13.5C22.0513 14.0523 22.0513 14.9477 21.499 15.5L15.999 21M3.49951 3.5L7.49997 7.50046M13 11C13 12.1046 12.1046 13 11 13C9.89543 13 9 12.1046 9 11C9 9.89543 9.89543 9 11 9C12.1046 9 13 9.89543 13 11Z"
          />
        <% "projects" -> %>
          <path d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2" />
          <path class="navigation-stack-middle" d="M19 11V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2M7 7h10" />
          <path class="navigation-stack-top" d="M7 7V5a2 2 0 012-2h6a2 2 0 012 2v2" />
        <% "things" -> %>
          <g class="navigation-book-first" stroke-width="1.75">
            <rect x="3" y="5" width="4" height="15" rx="1" />
            <path d="M3 9h4" />
          </g>
          <g class="navigation-book-middle" stroke-width="1.75">
            <rect x="10" y="4" width="4" height="16" rx="1" />
            <path d="M10 16h4" />
          </g>
          <g class="navigation-book-last" stroke-width="1.75">
            <rect x="17" y="6" width="4" height="14" rx="1" />
            <path d="M17 10h4" />
          </g>
      <% end %>
    </svg>
    """
  end
end
