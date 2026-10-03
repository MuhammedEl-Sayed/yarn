# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration (shared by all environments)
import Config

config :spark,
  formatter: ["Ash.Resource": [section_order: [:authentication, :token, :user_identity]]]

config :ash, default_string_length_count: :codepoints

config :spool,
  ecto_repos: [Spool.Repo],
  generators: [timestamp_type: :utc_datetime],
  # Domains only, not resources.
  ash_domains: [Spool.Accounts, Spool.Tasks, Spool.Rooms]

# Required by AshJsonApi: lets Phoenix treat application/vnd.api+json as JSON
config :mime,
  extensions: %{"json" => "application/vnd.api+json"},
  types: %{"application/vnd.api+json" => ["json"]}

# Endpoint
config :spool, SpoolWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SpoolWeb.ErrorHTML, json: SpoolWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Spool.PubSub,
  live_view: [signing_salt: "oh5XDAUQ"]

config :phoenix_live_view,
  root_tag_attribute: "phx-r"

# Mailer: Local adapter by default (see /dev/mailbox). Prod is set in runtime.exs.
config :spool, Spool.Mailer, adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.25.4",
  spool: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

config :tailwind,
  version: "4.3.3",
  spool: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Must remain at the bottom so env files override the above.
import_config "#{config_env()}.exs"
