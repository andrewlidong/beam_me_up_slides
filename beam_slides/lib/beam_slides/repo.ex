defmodule BeamSlides.Repo do
  use Ecto.Repo,
    otp_app: :beam_slides,
    adapter: Ecto.Adapters.Postgres
end
