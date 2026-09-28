import Config

# Runtime config for all environments. Secrets come from environment variables only.

if System.get_env("PHX_SERVER") do
  config :spool, SpoolWeb.Endpoint, server: true
end

port = String.to_integer(System.get_env("PORT", "4000"))

config :spool, SpoolWeb.Endpoint, http: [port: port]

if config_env() == :dev do
  config :spool, SpoolWeb.Endpoint,
    live_reload: [
      web_console_logger: true,
      patterns: [
        ~r"priv/static/(?!uploads/).*\.(js|css|png|jpeg|jpg|gif|svg)$",
        ~r"priv/gettext/.*\.po$",
        ~r"lib/spool_web/router\.ex$",
        ~r"lib/spool_web/(controllers|live|components)/.*\.(ex|heex)$"
      ]
    ]
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :spool, Spool.Repo,
    # Local Postgres on the same Pi: no SSL needed.
    # For a remote DB, add: ssl: true
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  token_signing_secret =
    System.get_env("TOKEN_SIGNING_SECRET") ||
      raise "environment variable TOKEN_SIGNING_SECRET is missing."

  host = System.get_env("PHX_HOST") || "localhost"

  # Plain HTTP on LAN by default. Behind an HTTPS proxy set:
  #   PHX_SCHEME=https PHX_URL_PORT=443
  scheme = System.get_env("PHX_SCHEME") || "http"
  url_port = String.to_integer(System.get_env("PHX_URL_PORT") || Integer.to_string(port))

  config :spool, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :spool, SpoolWeb.Endpoint,
    url: [host: host, port: url_port, scheme: scheme],
    http: [
      # IPv6 + bind on all interfaces (also accepts IPv4).
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :spool, token_signing_secret: token_signing_secret

  # Mailer: configure a real adapter to send auth emails in prod.
  # Example (Mailgun):
  #
  # config :spool, Spool.Mailer,
  #   adapter: Swoosh.Adapters.Mailgun,
  #   api_key: System.get_env("MAILGUN_API_KEY"),
  #   domain: System.get_env("MAILGUN_DOMAIN")
end
