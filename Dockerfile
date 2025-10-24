FROM elixir:1.19.1

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the environment variable for production
ENV MIX_ENV=prod

# Copy the application
WORKDIR /app
COPY mix.exs mix.lock ./
COPY config ./config
COPY priv ./priv

# Install dependencies
RUN mix deps.get --only prod
RUN mix deps.compile

COPY lib ./lib
RUN mix compile

# Expose the port
EXPOSE 4000

# Run the application
CMD ["mix", "run", "--no-halt"]