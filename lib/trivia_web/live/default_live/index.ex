defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger
  alias TriviaWeb.SharedData

  alias Trivia.Arenas
  alias Trivia.Arenas.Arena
  alias Trivia.ArenaThemeContext

  @impl true
  def mount(_params, _session, socket) do
    links = SharedData.links()
    # IO.inspect(socket.assigns.current_user, label: "Current User")

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
    # IO.inspect(arenas, label: "List of arenas")

    socket =
      socket
      |> assign(:page_title, "Home Page")
      |> assign(:links, links)
      |> assign(:arenas, arenas)

    # {:ok, stream(socket, :arenas, arenas)}
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

# <div class="">
# <%= if @empty_data do %>
#   <div class="flex items-center justify-center mt-20">
#     <p>No arena to display right now!!</p>
#   </div>
#   <% else %>
#     <div class="flex flex-col gap-4">
#       <%= for {id, arena} <- @streams.arenas do %>
#         <div id={"arena-#{id}"} class="arena-item">
#           <p>ID: <%= id %>
#           </p>
#           <p>Players: <%= arena.no_of_players %>
#           </p>
#         </div>
#         <% end %>
#     </div>
#     <% end %>
# </div>

# def handle_info({TriviaWeb.ArenaLive.FormComponent, {:deleted, arena}}, socket) do
#   updated_arenas = List.delete(socket.assigns.arenas, arena)  # Remove the deleted arena
#   {:noreply, assign(socket, :arenas, updated_arenas)}
# end

# def handle_info({TriviaWeb.ArenaLive.FormComponent, {:updated, updated_arena}}, socket) do
#   updated_arenas =
#     Enum.map(socket.assigns.arenas, fn
#       arena when arena.id == updated_arena.id -> updated_arena  # Replace the arena with the updated one
#       arena -> arena  # Leave other arenas unchanged
#     end)

#   {:noreply, assign(socket, :arenas, updated_arenas)}
# end
