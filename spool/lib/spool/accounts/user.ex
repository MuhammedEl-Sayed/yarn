defmodule Spool.Accounts.User do
  use Ash.Resource,
    otp_app: :spool,
    domain: Spool.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication, AshJsonApi.Resource]

  postgres do
    table("users")
    repo(Spool.Repo)
  end

  json_api do
    type "user"
  end

  policies do
    bypass(AshAuthentication.Checks.AshAuthenticationInteraction) do
      authorize_if(always())
    end

    
    policy action([:read, :me]) do
      authorize_if actor_present()
    end
    end

  authentication do
    add_ons do
      log_out_everywhere do
        apply_on_password_change? true
      end
    end

    tokens do
      enabled? true
      token_resource Spool.Accounts.Token
      signing_secret Spool.Secrets
      store_all_tokens? true
      require_token_presence_for_authentication? true
    end

    strategies do
      api_key :api_key do
        api_key_relationship :valid_api_keys
        api_key_hash_attribute :api_key_hash
      end
    end
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string, allow_nil?: true, public?: true
  end
  

  relationships do
    has_many :valid_api_keys, Spool.Accounts.ApiKey do
      filter(expr(valid))
    end
  end

  actions do
    defaults([:read])

    read :me do
        get? true
        filter expr(id == ^actor(:id))
    end

    read :get_by_subject do
      description("Get a user by the subject claim in a JWT")
      argument(:subject, :string, allow_nil?: false)
      get?(true)
      prepare(AshAuthentication.Preparations.FilterBySubject)
    end

    read :sign_in_with_api_key do
      argument(:api_key, :string, allow_nil?: false)
      prepare(AshAuthentication.Strategy.ApiKey.SignInPreparation)
    end
create :create do
  accept [:name]
end
  end
end
