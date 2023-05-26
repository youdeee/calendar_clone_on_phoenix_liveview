FROM elixir:1.14.5

RUN mix local.hex --force && \
  mix archive.install hex phx_new 1.7.2 --force && \
  mix local.rebar --force

WORKDIR /app
