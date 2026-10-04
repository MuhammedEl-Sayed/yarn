defmodule Spool.Accounts do
  use Ash.Domain,
    otp_app: :spool,
    extensions: [AshJsonApi.Domain]
  json_api do
    routes do
      base_route "/users", Spool.Accounts.User do
        get :me, route: "/me"
        index :read
      end
    end
  end
  resources do
    resource Spool.Accounts.Token
    resource Spool.Accounts.User
    resource Spool.Accounts.ApiKey
  end
end
