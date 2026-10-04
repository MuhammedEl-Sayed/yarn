# lib/spool_web/ash_json_api_router.ex
defmodule SpoolWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Spool.Tasks, Spool.Rooms, Spool.Accounts],
    open_api: "/open_api"
end
