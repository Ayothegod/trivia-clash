defmodule TriviaWeb.ArenaLive.ArenaLobby do
  use TriviaWeb, :live_view

  alias Trivia.Arenas
  alias TriviaWeb.SharedData

  # alias Trivia.Arenas.Arena
  # alias Trivia.ArenaThemeContext

  @impl true
  def mount(_params, _session, socket) do
    links = SharedData.links()

    socket =
      case SharedData.profile(socket) do
        {:ok, %{user: userData}} ->
          assign(socket, :user, userData)

        {:error, :not_found} ->
          redirect(socket, to: "/users/logout_redirect")

        {:error, :unauthenticated} ->
          redirect(socket, to: "/users/log_in")
      end

    socket =
      socket
      |> assign(:links, links)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:arena, Arenas.get_arena!(id))}
  end

  defp page_title(:index), do: "Ayo's Lobby"
  defp page_title(:edit), do: "Edit Arena"
end
