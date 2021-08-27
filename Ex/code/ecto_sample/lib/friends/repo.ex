defmodule Friends.Repo do
  use Ecto.Repo,
    otp_app: :ecto_sample,
    adapter: Ecto.Adapters.Postgres
end
