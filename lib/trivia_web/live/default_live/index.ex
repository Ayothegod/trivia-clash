defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view

  # import TriviaWeb.Components.Button

  # alias Trivia.Arenas
  # alias Trivia.Arenas.Arena
  alias TriviaWeb.Components.Button, as: Button

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Home Page")
      |> assign(:index, "Home page here")
      |> assign(:default, "This is default data")

    {:ok, socket}
  end
end
