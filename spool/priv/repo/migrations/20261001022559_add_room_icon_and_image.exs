defmodule Spool.Repo.Migrations.AddRoomIconAndImage do
  @moduledoc """
  Creates rooms (if missing) and converts tasks.room_id from text to a
  uuid foreign key referencing rooms.id. Safe to run whether or not the
  rooms table already exists.
  """

  use Ecto.Migration

  def up do
    create_if_not_exists table(:rooms, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :created_by, :text, null: false
      add :name, :text, null: false
      add :assigned_to, {:array, :text}, default: []

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    # In case rooms already existed without these columns
    alter table(:rooms) do
      add_if_not_exists :image_path, :text
      add_if_not_exists :icon, :map
    end

    # Old text column can't be cast to uuid, so drop and re-add it.
    # Removing the column also removes any old foreign key on it.
    execute("ALTER TABLE tasks DROP CONSTRAINT IF EXISTS tasks_room_id_fkey")

    alter table(:tasks) do
      remove_if_exists :room_id, :text
    end

    execute("ALTER TABLE tasks DROP COLUMN IF EXISTS room_id")

    alter table(:tasks) do
      add :room_id,
          references(:rooms,
            column: :id,
            name: "tasks_room_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end
  end

  def down do
    execute("ALTER TABLE tasks DROP CONSTRAINT IF EXISTS tasks_room_id_fkey")
    execute("ALTER TABLE tasks DROP COLUMN IF EXISTS room_id")

    alter table(:tasks) do
      add :room_id, :text
    end

    drop_if_exists table(:rooms)
  end
end
