defmodule Spool.Rooms.Room do
  use Ash.Resource,
    domain: Spool.Rooms,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshJsonApi.Resource]

  postgres do
    table("rooms")
    repo(Spool.Repo)
  end

  json_api do
    type("room")
  end

  policies do
    policy always() do
      authorize_if actor_present()
    end
  end

  attributes do
    uuid_primary_key(:id)

    attribute :created_by, :string, allow_nil?: false, public?: true
    attribute :name, :string, allow_nil?: false, public?: true
    attribute :assigned_to, {:array, :string}, default: [], public?: true
    attribute :icon, :string, allow_nil?: true, public?: true

    attribute :color_index, :integer, allow_nil?: true, public?: true

    timestamps()
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([:created_by, :name, :assigned_to, :icon, :color_index])
    end

    update :update do
      accept([:name, :assigned_to, :color_index, :icon])
    end
  end
end
