defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger
  alias TriviaWeb.SharedData

  @impl true
  def mount(_params, _session, socket) do
    links = SharedData.links()

    socket =
      case SharedData.profile(socket) do
        {:ok, %{user: userData}} ->
          IO.inspect(userData.email, label: "User Email")
          assign(socket, :user, userData)

        {:error, :not_found} ->
          Logger.error("User not found!")
          redirect(socket, to: "/users/logout_redirect")

        {:error, :unauthenticated} ->
          Logger.error("User is unauthenticated!")
          redirect(socket, to: "/users/log_in")
      end

    socket =
      socket
      |> assign(:page_title, "Home Page")
      |> assign(:links, links)

    {:ok, socket}
  end
end
