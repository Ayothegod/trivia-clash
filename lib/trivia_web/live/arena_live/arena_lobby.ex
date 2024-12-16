defmodule TriviaWeb.ArenaLive.ArenaLobby do
  use TriviaWeb, :live_view

  alias Trivia.Arenas
  # alias Trivia.Arenas.Arena
  alias TriviaWeb.SharedData
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
  def handle_params(params, _url, socket) do
    apply_action(socket, socket.assigns.live_action, params)
  end

  defp apply_action(socket, :settings, %{"id" => id}) do
    # IO.inspect(id)
    arena = Arenas.get_arena!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Edit arena")
     |> assign(:arena, arena)}
  end

  defp apply_action(socket, :index, %{"id" => id}) do
    arena = Arenas.get_arena!(id)
    IO.inspect(arena)

    {:noreply,
     socket
     |> assign(:page_title, arena.name)
     |> assign(:arena, arena)}
  end

  @impl true
  def handle_event("exit-arena", %{"id" => id}, socket) do
    IO.inspect(id)
    # arena = Arenas.get_arena!(id)
    # {:ok, _} = Arenas.delete_arena(arena)
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    IO.inspect(id)
    # Logic to delete the profile by `id`
    # Profiles.delete_profile(id)

    # # Optionally update the socket's assigns or send a reply
    # {:noreply,
    #  update(socket, :profiles, fn profiles ->
    #    Enum.reject(profiles, &(&1.id == id))
    #  end)}
    {:noreply, socket}
  end
end
