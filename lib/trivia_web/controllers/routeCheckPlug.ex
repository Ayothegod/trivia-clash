defmodule TriviaWeb.RouteCheckPlug do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    excluded_routes = ["/users/log_in", "/users/register", "/users/log_out"]
    show_user_ui = !Enum.member?(excluded_routes, conn.request_path)
    assign(conn, :show_user_ui, show_user_ui)
  end
end
