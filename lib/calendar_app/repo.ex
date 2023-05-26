defmodule CalendarApp.Repo do
  use Ecto.Repo,
    otp_app: :calendar_app,
    adapter: Ecto.Adapters.Postgres
end
