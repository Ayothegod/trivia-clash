defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger

  # alias Trivia.Arenas
  # alias Trivia.Arenas.Arena
  # <.iconify icon={@my_icon} />
  @impl true
  def mount(_params, _session, socket) do
    # Logger.critical(session)
    # Logger.critical(socket)

    # socket.assigns.current_user.id

    socket =
      socket
      |> assign(:page_title, "Home Page")
      |> assign(:index, "Home page here")

    {:ok, socket}
  end
end
