import Config

config :spool, SpoolWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# force_ssl is a COMPILE-TIME setting.
# Running plain HTTP on a LAN Pi: leave this commented out.
# Running behind Caddy/nginx with HTTPS: uncomment it.
#
# config :spool, SpoolWeb.Endpoint,
#   force_ssl: [
#     rewrite_on: [:x_forwarded_proto],
#     exclude: [hosts: ["localhost", "127.0.0.1"]]
#   ]

config :swoosh, api_client: Swoosh.ApiClient.Req
config :swoosh, local: false

config :logger, level: :info
