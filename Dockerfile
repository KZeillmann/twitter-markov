FROM elixir:latest

RUN apt-get update && apt-get install -y \
  git

# pull latest version of phoenix
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

RUN mix local.hex --force \
  && mix local.rebar --force

WORKDIR .

EXPOSE 80

CMD ["mix phx.server"]
