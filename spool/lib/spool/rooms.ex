
defmodule Spool.Rooms do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  resources do
    resource Spool.Rooms.Room
  end

  json_api do
    routes do
      base_route "/rooms", Spool.Rooms.Room do
        get(:read)
        index(:read)
        post(:create)
        patch(:update)
        delete(:destroy)
      end
    end
  end
end
