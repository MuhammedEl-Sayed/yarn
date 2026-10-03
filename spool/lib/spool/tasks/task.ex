defmodule Spool.Tasks.Task do
  use Ash.Resource,
    domain: Spool.Tasks,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshJsonApi.Resource]

  postgres do
    table("tasks")
    repo(Spool.Repo)
  end

  json_api do
    type("task")
  end

  policies do
    policy always() do
      authorize_if actor_present()
    end
  end

  relationships do
    belongs_to :room, Spool.Rooms.Room do
      allow_nil? true
      public? true
    end
  end

  attributes do
    uuid_primary_key(:id)

    attribute :created_by, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :name, :string do
      allow_nil?(false)
      public?(true)
    end

    attribute :is_active, :boolean do
      default(true)
      public?(true)
    end

    attribute :description, :string do
      allow_nil?(true)
      public?(true)
    end

    attribute :rep_unit, Spool.Tasks.Task.RepUnit do
      allow_nil?(false)
      public?(true)
    end

    attribute :every, :integer do
      allow_nil?(true)
      public?(true)
    end

    attribute :repeats_on, {:array, :string} do
      default([])
      public?(true)
    end

    attribute :monthly_on, :integer do
      allow_nil?(false)
      public?(true)
    end

    attribute :last_completed, :utc_datetime_usec do
      allow_nil?(true)
      public?(true)
    end

    attribute :assigned_to, {:array, :string} do
      default([])
      public?(true)
    end

    timestamps()
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([
        :created_by,
        :name,
        :is_active,
        :description,
        :rep_unit,
        :every,
        :repeats_on,
        :monthly_on,
        :last_completed,
        :assigned_to,
        :room_id,
      ])
    end

    update :update do
      accept([
        :name,
        :is_active,
        :description,
        :rep_unit,
        :every,
        :repeats_on,
        :monthly_on,
        :last_completed,
        :assigned_to,
        :room_id
      ])
    end
  end
end
