defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger

  alias TriviaWeb.SharedData

  @impl true
  def mount(_params, session, socket) do
    links = SharedData.links()
    profile = TriviaWeb.SharedData.profile(socket, session)
    IO.inspect(profile, label: "shared profile")
    IO.inspect(links, label: "shared links")

    socket =
      socket
      |> assign(:profile, profile)
      |> assign(:page_title, "Home Page")

    {:ok, socket}
  end

  # def render(assigns) do
  #   Logger.debug("Received data: #{inspect(assigns)}")
  # end
end
