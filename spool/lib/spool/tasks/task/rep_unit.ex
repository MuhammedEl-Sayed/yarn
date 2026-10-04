defmodule Spool.Tasks.Task.RepUnit do
  use Ash.Type.Enum, values: [:once, :day, :week, :month, :year]
end

