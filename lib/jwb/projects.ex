defmodule Jwb.Projects do
  @moduledoc """
  Module for working with projects.
  """

  alias Jwb.Projects.Project

  projects_paths = "lib/jwb/projects/*.md" |> Path.wildcard() |> Enum.sort()

  projects =
    for project_path <- projects_paths do
      @external_resource Path.relative_to_cwd(project_path)
      Project.parse!(project_path)
    end

  @projects Enum.sort_by(projects, & &1.position)

  def list_projects do
    @projects
  end

  def get_project(slug) do
    case Enum.find(@projects, &(&1.slug == slug)) do
      nil -> {:error, :not_found}
      project -> project
    end
  end
end
