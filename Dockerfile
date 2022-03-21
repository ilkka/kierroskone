# Defaults for use later, these aren't actually visible inside the stages
# unless there's another arg clause in the stage.
ARG USERNAME=kierroskone
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG ELIXIR_VERSION=1.13.3


## **********************************************************************
## Base stage for dependencies and tools for dev, build and test
## **********************************************************************
FROM elixir:${ELIXIR_VERSION} as base
LABEL maintainer="Ilkka Poutanen <ilkka.poutanen@futurice.com>"

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
	&& apt-get update \
	&& apt-get install -y \
	nodejs \
	postgresql-client \
	locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Non-root user for dev stuff etc
ARG USERNAME
ARG USER_UID
ARG USER_GID

ARG WORKDIR=/app

RUN mix local.hex --force \
	&& mix local.rebar --force

WORKDIR /app
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile
COPY . ./


## **********************************************************************
## Build sources from base stage
## **********************************************************************
FROM base as build
ENV MIX_ENV=prod
RUN mix do deps.compile, phx.digest, compile


## **********************************************************************
## Package release
## **********************************************************************
FROM build as release
RUN mix release


## **********************************************************************
## Run release in production mode
## **********************************************************************
FROM debian:bullseye-20220316-slim as deploy
LABEL maintainer="Ilkka Poutanen <ilkka.poutanen@futurice.com>"
RUN apt-get update \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get install -y libssl1.1 \
	&& rm -rf /var/lib/apt/lists/*
ARG USERNAME
ARG USER_UID
ARG USER_GID
RUN groupadd --gid $USER_GID $USERNAME \
	&& useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
WORKDIR /app
COPY --from=release --chown=${USERNAME} /app/_build/prod/rel ./
USER $USERNAME
ENV LC_ALL=C.UTF-8 LANG=C.UTF-8
CMD ["/app/kierroskone/bin/kierroskone", "start"]