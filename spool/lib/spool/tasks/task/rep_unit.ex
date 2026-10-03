defmodule Spool.Tasks.Task.RepUnit do
  use Ash.Type.Enum, values: [:day, :week, :month]
end
