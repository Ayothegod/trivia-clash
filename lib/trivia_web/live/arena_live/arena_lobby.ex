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
    arena = Arenas.get_arena_with_theme_players!(id)
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

    # %Trivia.Arenas.Arena{
    #   __meta__: #Ecto.Schema.Metadata<:loaded, "arenas">,
    #   id: "e38d864b-b6c1-4014-9ce6-133f80e8ed98",
    #   public: true,
    #   players: [%{"id" => 18, "is_player" => true}],
    #   no_of_players: 2,
    #   observer_capacity: 6,
    #   name: "Test arena",
    #   theme_id: "b8dc7896-8b5a-4313-8e1a-894611e74b14",
    #   arena_theme: #Ecto.Association.NotLoaded<association :arena_theme is not loaded>,
    #   inserted_at: ~U[2024-12-14 20:37:25Z],
    #   updated_at: ~U[2024-12-14 20:37:25Z]
    # }
    {:noreply, socket}
  end
end
