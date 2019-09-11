defmodule PhxClient.Repo do
  use Ecto.Repo,
    otp_app: :phx_client,
    adapter: Ecto.Adapters.Postgres
end
