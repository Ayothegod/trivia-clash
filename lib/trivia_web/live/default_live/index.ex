defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger
  alias TriviaWeb.SharedData

  alias Trivia.Arenas
  alias Trivia.Arenas.Arena
  alias Trivia.ArenaThemeContext

  # embed_templates "components/*"

  @impl true
  def mount(_params, _session, socket) do
    links = SharedData.links()

    socket =
      case SharedData.profile(socket) do
        {:ok, %{user: userData}} ->
          assign(socket, :user, userData)

        {:error, :not_found} ->
          Logger.error("User not found!")
          redirect(socket, to: "/users/logout_redirect")

        {:error, :unauthenticated} ->
          Logger.error("User is unauthenticated!")
          redirect(socket, to: "/users/log_in")
      end

    arenas = Arenas.list_arenas()
    # IO.inspect(arenas)

    socket =
      socket
      |> assign(:page_title, "Home Page")
      |> assign(:links, links)
      |> assign(:arenas, arenas)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Arena")
    |> assign(:arena, Arenas.get_arena!(id))
  end

  defp apply_action(socket, :new, _params) do
    arena_themes = ArenaThemeContext.get_theme_for_select()

    socket
    |> assign(:page_title, "New Arena")
    |> assign(:arena, %Arena{})
    |> assign(:arena_themes, arena_themes)
    |> assign(:currentUser, socket.assigns.current_user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Home")
    |> assign(:arena, nil)
  end

  @impl true
  def handle_info({TriviaWeb.ArenaLive.FormComponent, {:saved, arena}}, socket) do
    # {:noreply, stream_insert(socket, :arenas, arena)}
    IO.inspect("got here")
    updated_arenas = [arena | socket.assigns.arenas]
    {:noreply, assign(socket, :arenas, updated_arenas)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    arena = Arenas.get_arena!(id)
    {:ok, _} = Arenas.delete_arena(arena)
    {:noreply, stream_delete(socket, :arenas, arena)}
  end
end
