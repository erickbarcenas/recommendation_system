# RecommendationSystem

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  * Bolt_sips: https://github.com/florinpatrascu/bolt_sips#installation



# Configuration
Go to `mix.exs` file add `{:bolt_sips, "~> 2.0"}, {:poison, "~> 5.0"}` and execute `mix deps.get; mix deps.compile`
```elixir
defp deps do
  [
    {:phoenix, "~> 1.6.6"},
    {:phoenix_ecto, "~> 4.4"},
    {:ecto_sql, "~> 3.6"},
    {:postgrex, ">= 0.0.0"},
    {:phoenix_html, "~> 3.0"},
    {:phoenix_live_reload, "~> 1.2", only: :dev},
    {:phoenix_live_view, "~> 0.17.5"},
    {:floki, ">= 0.30.0", only: :test},
    {:phoenix_live_dashboard, "~> 0.6"},
    {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
    {:swoosh, "~> 1.3"},
    {:telemetry_metrics, "~> 0.6"},
    {:telemetry_poller, "~> 1.0"},
    {:gettext, "~> 0.18"},
    {:jason, "~> 1.2"},
    {:plug_cowboy, "~> 2.5"},
    {:bolt_sips, "~> 2.0"},
    {:poison, "~> 5.0"}
  ]
end

```

2. En  `dev.exs`comentar el código y agregar el siguiente 
```elixir
# Configure your database
# config :recommendation_system, RecommendationSystem.Repo,
#   username: "postgres",
#   password: "postgres",
#   hostname: "localhost",
#   database: "recommendation_system_dev",
#   show_sensitive_data_on_connection_error: true,
#   pool_size: 10
```

```elixir
config :bolt_sips, Bolt,
  url: "bolt://e<*****>.databases.neo4j.io",
  basic_auth: [username: "neo4j", password: "a--<*******>"],
  pool_size: 10,
  ssl: true,
  max_overflow: 2,
  queue_interval: 500,
  queue_target: 1500,
  prefix: :default
```

3. En `lib/recommendation_system/application.ex` añadir `{Bolt.Sips, Application.get_env(:bolt_sips, Bolt)}` y comentar `RecommendationSystem.Repo`

```elixir 
def start(_type, _args) do
  children = [
    # Start Bolt_sips supervisor
    {Bolt.Sips, Application.get_env(:bolt_sips, Bolt)}
    # Start the Ecto repository
    # RecommendationSystem.Repo,
    # Start the Telemetry supervisor
    RecommendationSystemWeb.Telemetry,
    # Start the PubSub system
    {Phoenix.PubSub, name: RecommendationSystem.PubSub},
    # Start the Endpoint (http/https)
    RecommendationSystemWeb.Endpoint
    # Start a worker by calling: RecommendationSystem.Worker.start_link(arg)
    # {RecommendationSystem.Worker, arg}
  ]
  # See https://hexdocs.pm/elixir/Supervisor.html
  # for other strategies and supported options
  opts = [strategy: :one_for_one, name: RecommendationSystem.Supervisor]
  Supervisor.start_link(children, opts)
end
```

4. En `lib/recommendation_system/repo.ex` el código por default se debe de borrar
y añadir nuevo código. El resultado debe de ser:

```elixir
defmodule RecommendationSystem.Repo do
  alias Bolt.Sips, as: Neo
  def users_list do
    cypher = """
              MATCH (u:User)
              RETURN u.uid AS uid, u.name AS name
            """
    case Neo.query(Neo.conn(), cypher) do
      {:ok,  %Bolt.Sips.Response{results: results}} -> 
        results 
        |> Enum.map(fn user -> 
          %{
            uid: user["uid"],
            name: user["name"],
            gender: user["gender"]
          }
         end)
      {:error, response} -> response.message
    end
  end
end
```