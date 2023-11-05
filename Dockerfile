FROM --platform=linux/arm/v7 elixir:1.15.7
COPY . /src
WORKDIR /src
ENV MIX_ENV=prod
RUN mix local.hex --force && mix local.rebar --force && mix deps.get
ENTRYPOINT yes | mix release
