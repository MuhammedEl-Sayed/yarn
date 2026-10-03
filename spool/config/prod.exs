import Config

config :spool, SpoolWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# force_ssl is a COMPILE-TIME setting. Traefik terminates TLS and sends
# X-Forwarded-Proto, so redirect plain HTTP to HTTPS.
config :spool, SpoolWeb.Endpoint,
  force_ssl: [
    rewrite_on: [:x_forwarded_proto],
    exclude: [hosts: ["localhost", "127.0.0.1"]]
  ]

config :swoosh, api_client: Swoosh.ApiClient.Req
config :swoosh, local: false

config :logger, level: :info
