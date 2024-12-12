defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger

  alias TriviaWeb.SharedData

  @impl true
  def mount(_params, session, socket) do
    links = SharedData.links()
    profile = TriviaWeb.SharedData.profile(socket, session)
    IO.inspect(profile, label: "default profile")
    IO.inspect(links, label: "default links")

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

# <% if @is_admin %>
# <div class="flex gap-2 items-center">
#   <.link href={~p"/users/log_out"} method="delete">
#     <Button.button size="medium">
#       Log out
#     </Button.button>
#   </.link>

#   <p>Welcome to your account</p>
# </div>
# <% else %>
#   <div class="flex gap-2 items-center">
#     <.link href={~p"/users/log_out"} method="delete">
#       <Button.button size="medium">
#         Log In
#       </Button.button>
#     </.link>
#   </div>
#   <% end %>
