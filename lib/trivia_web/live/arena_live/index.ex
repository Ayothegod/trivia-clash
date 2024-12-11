defmodule TriviaWeb.ArenaLive.Index do
  use TriviaWeb, :live_view

  alias Trivia.Arenas
  alias Trivia.Arenas.Arena

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :arenas, Arenas.list_arenas())}
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
    socket
    |> assign(:page_title, "New Arena")
    |> assign(:arena, %Arena{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Arenas")
    |> assign(:arena, nil)
  end

  @impl true
  def handle_info({TriviaWeb.ArenaLive.FormComponent, {:saved, arena}}, socket) do
    {:noreply, stream_insert(socket, :arenas, arena)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    arena = Arenas.get_arena!(id)
    {:ok, _} = Arenas.delete_arena(arena)

    {:noreply, stream_delete(socket, :arenas, arena)}
  end
end
