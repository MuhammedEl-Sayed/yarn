defmodule Spool.Tasks do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource Spool.Tasks.Task
  end

  json_api do
    routes do
      base_route "/tasks", Spool.Tasks.Task do
        get(:read)
        index(:read)
        post(:create)
        patch(:update)
        delete(:destroy)
      end
    end
  end
end
