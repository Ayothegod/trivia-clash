defmodule TriviaWeb.UserAssignPlug do
  import Plug.Conn
  import Phoenix.Controller
  require Logger

  alias TriviaWeb.SharedData

  def init(default), do: default

  def call(conn, _opts) do
    case SharedData.profile(conn) do
      {:ok, %{user: userData}} ->
        assign(conn, :user, userData)

      {:error, :not_found} ->
        Logger.error("User not found!")

        # Avoid redirect loop if already on login page
        if conn.request_path != "/users/log_in" do
          conn
          |> redirect(to: "/onboarding")
          |> halt()
        else
          conn
        end

      {:error, :unauthenticated} ->
        Logger.error("User is unauthenticated!")

        # Avoid redirect loop if already on login page
        if conn.request_path != "/users/log_in" do
          conn
          |> redirect(to: "/users/log_in")
          |> halt()
        else
          conn
        end
    end
  end
end

# defmodule TriviaWeb.UserAssignPlug do
#   import Plug.Conn
#   import Phoenix.Controller
#   require Logger

#   alias TriviaWeb.SharedData

#   def init(default), do: default

#   def call(conn, _opts) do
#     case SharedData.profile(conn) do
#       {:ok, %{user: userData}} ->
#         assign(conn, :user, userData)

#       {:error, :not_found} ->
#         Logger.error("User not found!")

#         conn
#         |> redirect(to: "/onboarding")
#         |> halt()

#       {:error, :unauthenticated} ->
#         Logger.error("User is unauthenticated!")

#         conn
#         |> redirect(to: "/users/log_in")
#         |> halt()
#     end
#   end
# end
