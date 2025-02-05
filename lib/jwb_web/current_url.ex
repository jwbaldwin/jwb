defmodule JwbWeb.CurrentURL do
  def on_mount(:current_path, _params, _session, socket) do
    {:cont,
     Phoenix.LiveView.attach_hook(socket, :current_url, :handle_params, &save_request_path/3)}
  end

  defp save_request_path(_params, url, socket) do
    {:cont, Phoenix.Component.assign(socket, :current_url, URI.parse(url))}
  end
end
