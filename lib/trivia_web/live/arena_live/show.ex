defmodule TriviaWeb.ArenaLive.Show do
  use TriviaWeb, :live_view

  alias Trivia.Arenas

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:arena, Arenas.get_arena!(id))}
  end

  defp page_title(:show), do: "Show Arena"
  defp page_title(:edit), do: "Edit Arena"
end
