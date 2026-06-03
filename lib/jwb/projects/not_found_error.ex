defmodule Jwb.Projects.NotFoundError do
  defexception message: "Project not found", plug_status: 404
end
