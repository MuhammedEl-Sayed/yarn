defmodule SpoolWeb.PageController do
  use SpoolWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
