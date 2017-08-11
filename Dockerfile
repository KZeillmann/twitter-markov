FROM elixir:latest

RUN apt-get update && apt-get install -y \
  git

# pull latest version of phoenix
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

RUN mix local.hex --force \
  && mix local.rebar --force

ENV MIX_ENV prod

RUN mkdir /app

COPY . /app/

WORKDIR /app

RUN mix do deps.get, compile, phx.digest, compile, release

EXPOSE 80

ENTRYPOINT ["_build/dev/rel/twitter_markov/bin/twitter_markov", "foreground"]
