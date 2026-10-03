import Config

# Database (local Postgres). Password can be overridden in dev.secret.exs.
config :spool, Spool.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "spool_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# secret_key_base is NOT set here. It lives in config/dev.secret.exs (gitignored).
config :spool, SpoolWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:spool, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:spool, ~w(--watch)]}
  ]

config :spool, dev_routes: true

config :logger, :default_formatter, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false

# Local secrets (gitignored). Copy dev.secret.exs.example to dev.secret.exs.
secret_file = Path.expand("dev.secret.exs", __DIR__)

if File.exists?(secret_file) do
  import_config "dev.secret.exs"
else
  IO.warn("config/dev.secret.exs not found. Copy config/dev.secret.exs.example to create it.")
end
