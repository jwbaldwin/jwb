defmodule JwbWeb.ProjectsLive do
  use JwbWeb, :live_view

  alias Jwb.Projects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, %{assigns: %{live_action: :index}} = socket) do
    {:noreply, assign(socket, projects: Projects.list_projects(), page_title: "Projects")}
  end

  def handle_params(%{"slug" => slug}, _, %{assigns: %{live_action: :show}} = socket) do
    case Projects.get_project(slug) do
      {:error, :not_found} -> raise Projects.NotFoundError
      project -> {:noreply, assign(socket, project: project, page_title: project.name)}
    end
  end

  @impl true
  def render(%{live_action: :index} = assigns) do
    ~H"""
    <section class="projects-page">
      <header class="projects-intro">
        <h1>Projects</h1>
        <p>
          Products and experiments I've built. A look at the problems, the interfaces, and the engineering behind them.
        </p>
      </header>
      <ul class="projects-list">
        <li :for={project <- @projects}>
          <.link
            navigate={~p"/projects/#{project.slug}"}
            class="project-entry"
            data-project={project.slug}
          >
            <span class="project-mark">
              <img src={project.cover} alt="" width="48" height="48" />
            </span>
            <span class="project-entry-copy">
              <span class="project-entry-title">{project.name}</span>
              <span class="project-entry-description">{project.description}</span>
              <span class="project-category">{project.category}</span>
            </span>
            <span class="project-entry-arrow" aria-hidden="true">→</span>
          </.link>
        </li>
      </ul>
    </section>
    """
  end

  def render(%{live_action: :show} = assigns) do
    ~H"""
    <article class="projects-page project-detail">
      <.link navigate={~p"/projects"} class="project-back">← All projects</.link>
      <header class="project-header">
        <div class="project-heading">
          <span class="project-mark">
            <img src={@project.cover} alt="" width="48" height="48" />
          </span>
          <div>
            <div class="project-category">{@project.category}</div>
            <h1>{@project.name}</h1>
          </div>
        </div>
        <p class="project-summary">{@project.description}</p>
      </header>
      <div class="prose prose-invert project-story">{raw(@project.body)}</div>
      <div :if={@project.gallery != []} class="project-gallery">
        <figure :for={image <- @project.gallery}>
          <a href={image["src"]} aria-label={"View full-size image: #{image["alt"]}"}>
            <img
              src={image["src"]}
              alt={image["alt"]}
              width={image["width"]}
              height={image["height"]}
              loading="lazy"
              decoding="async"
            />
          </a>
          <figcaption>{image["caption"]}</figcaption>
        </figure>
      </div>
      <footer class="project-footer">
        <.link navigate={~p"/projects"} class="project-back">← All projects</.link>
      </footer>
    </article>
    """
  end
end
