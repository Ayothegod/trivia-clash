defmodule TriviaWeb.ArenaLive.ArenaLobby do
  use TriviaWeb, :live_view

  alias Trivia.Arenas
  alias Trivia.Arenas.ArenaPlayers
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
    arena = Arenas.get_arena_with_theme_players!(id)
    # IO.inspect(arena)
    # IO.inspect(socket.assigns)

    {:noreply,
     socket
     |> assign(:page_title, arena.name)
     |> assign(:arena, arena)}
  end

  @impl true
  def handle_event("exit-arena", %{"id" => id}, socket) do
    user = socket.assigns.current_user
    arena = Arenas.get_arena_with_players!(id)

    for player <- arena.arena_players do
      if player.user_id !== user.id do
        {:noreply, socket}
      end

      if player.is_player do
        case ArenaPlayers.update_arena_players(player, %{is_player: false}) do
          {:ok, arena_player} ->
            IO.inspect(arena_player.is_player, label: "Players updated")

            socket
            |> put_flash(:info, "Player has left the arena.")

          {:error, %Ecto.Changeset{} = changeset} ->
            IO.inspect(changeset, label: "error")
            {:noreply, assign(socket, form: to_form(changeset))}
        end
      end

      if player.is_host do
        IO.inspect("You cant be host")
      end

      IO.inspect("got here 2")
    end

    IO.inspect("got here 3")
    # |> push_navigate(to: "/arenas/#{arena.id}", replace: true)
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
