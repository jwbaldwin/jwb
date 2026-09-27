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
    <section class="projects-page projects-index">
      <header class="page-header">
        <JwbWeb.PageIllustration.page_illustration name="projects" />
        <h1 class="page-title">Projects</h1>
        <p class="page-intro">
          Products and experiments I've built.
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
              <img src={project.cover} alt="" width="32" height="32" />
            </span>
            <span class="project-entry-copy">
              <span class="project-entry-title list-title">{project.name}</span>
              <span class="project-category metadata">{project.category}</span>
            </span>
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
            <div class="project-category metadata">{@project.category}</div>
            <h1 class="page-title">{@project.name}</h1>
          </div>
        </div>
        <p class="project-summary page-intro">{@project.description}</p>
      </header>
      <div class="prose prose-invert reading-content project-story">{raw(@project.body)}</div>
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
          <figcaption class="metadata">{image["caption"]}</figcaption>
        </figure>
      </div>
      <footer class="project-footer">
        <.link navigate={~p"/projects"} class="project-back">← All projects</.link>
      </footer>
    </article>
    """
  end
end
