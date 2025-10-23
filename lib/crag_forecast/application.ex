defmodule CragForecast.Application do
  alias CragForecast.Repo
  @crag_loader Application.compile_env(:crag_forecast, :crag_loader)
  @port Application.compile_env(:crag_forecast, :port)

  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    # Print a startup message
    Logger.info("Starting CragForecast Application with #{Mix.env()} configuration...")

    # 1. Define only the core children needed for setup (just the Repo)
    core_children = [
      CragForecast.Repo
    ]

    opts = [strategy: :one_for_one, name: CragForecast.Supervisor]
    # 2. Start the supervisor with only the core children
    {:ok, pid} = Supervisor.start_link(core_children, opts)

    # 3. Perform all database setup tasks sequentially
    run_database_setup()

    # 4. If setup is successful, dynamically start the web server
    web_server_child_spec = {Bandit, plug: CragForecast.HTTP.Router, scheme: :http, port: @port}
    case Supervisor.start_child(pid, web_server_child_spec) do
      {:ok, _web_pid} ->
        Logger.info("Bandit web server started successfully.")
        {:ok, pid}
      {:error, reason} ->
        Logger.emergency("Failed to start the web server: #{inspect(reason)}")
        {:error, reason}
    end
  end

  # Helper function to keep the start/2 function clean
  defp run_database_setup() do
    # Run migrations
    Ecto.Migrator.run(CragForecast.Repo, :up, all: true)

    # Load crag data
    Logger.info("Loading crag data...")
    case @crag_loader.load_crags() do
      {:ok, crags} ->
        # Insert each crag into the database
        Enum.each(crags, fn crag ->
          Repo.insert!(crag, on_conflict: :nothing)
        end)
        Logger.info("Loaded #{length(crags)} crags successfully.")
      {:error, reason} ->
        # If loading fails, we crash the entire startup process.
        Logger.emergency("Failed to load crag data: #{inspect(reason)}")
        # Raise an exception to halt the boot process immediately
        raise "Crag data loading failed: #{inspect(reason)}"
    end
  end
end
