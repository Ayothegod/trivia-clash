defmodule Link do
  defstruct [:id, :title, :url]
end

# dropdown = %{
#   %Link{id: 1, title: "Profile", url: "/profile"},
#   %Link{id: 2, title: "Settings", url: "/settings"},
#   %Link{id: 1, title: "Log Out", url: "/logout"}
# }

defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger
  # <.iconify icon={@my_icon} />

  @impl true
  def mount(_params, session, socket) do
    user_profile = session["user_profile"]

    links = [
      %{id: 1, title: "Profile", url: "profile", icon: "heroicons:rectangle-stack-16-solid"},
      %{id: 2, title: "Settings", url: "settings", icon: "heroicons:rectangle-stack-16-solid"},
      %{id: 3, title: "Log out", url: "logout", icon: "heroicons:rectangle-stack-16-solid"}
    ]

    # testIcon = "heroicons:rectangle-stack-16-solid"

    socket =
      socket
      |> assign(:index, "Home page here")
      |> assign(:page_title, "Home Page")
      |> assign(:user_profile, user_profile)
      |> assign(:links, links)

    {:ok, socket}
  end
end

# if loaded?(user) do
#   # Access user data (e.g., user.email)
# else
#   # User data is not loaded, handle appropriately
# end
