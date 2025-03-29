# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian
# instead of Alpine to avoid DNS resolution issues in production.
FROM elixir:1.14.3-slim as builder

# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Prepare build dir
WORKDIR /app

# Install hex packages
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV
ENV MIX_ENV="prod"

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy config and secrets
COPY config/config.exs config/${MIX_ENV}.exs config/

# Copy the rest of the application
COPY . .

# Fetch and compile dependencies
RUN mix deps.get --only $MIX_ENV && \
    mix deps.compile

# Build assets
RUN mix assets.deploy

RUN mix do compile, release

# Start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM debian:bullseye-slim

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set runner ENV
ENV MIX_ENV="prod"

WORKDIR "/app"
RUN chown nobody /app

# Set runner user
USER nobody

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/beam_slides ./
COPY --from=builder --chown=nobody:root /app/priv/static ./priv/static

CMD ["/app/bin/server"] 