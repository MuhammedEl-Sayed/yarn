defmodule Spool.Accounts do
  use Ash.Domain,
    otp_app: :spool

  resources do
    resource Spool.Accounts.Token
    resource Spool.Accounts.User
    resource Spool.Accounts.ApiKey
  end
end
