defmodule Jwb.Repo do
  use Ecto.Repo,
    otp_app: :jwb,
    adapter: Ecto.Adapters.Postgres
end
