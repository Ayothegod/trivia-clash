defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  # alias Trivia.Arenas
  # alias Trivia.Arenas.Arena
  # <.iconify icon={@my_icon} />

  alias TriviaWeb.Components.Button, as: Button

  @impl true
  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(_params, _session, socket) do

    # socket.assigns.current_user.id)
    user = %{name: "ayomide"}

    socket =
      socket
      |> assign(:page_title, "Home Page") 
      |> assign(:user, user)
      |> assign(:index, "Home page here")
      |> assign(:default, "This is default data")

    {:ok, socket}
  end
end
