defmodule TriviaWeb.DefaultLive.Index do
  use TriviaWeb, :live_view
  require Logger
  # <.iconify icon={@my_icon} />

  @impl true
  def mount(_params, session, socket) do
    user_profile = session["user_profile"]
    # IO.inspect(user_profile, label: "PROFILE!!!!!!!!!!!!!!")

    socket =
      socket
      |> assign(:logoUrl, "/")
      |> assign(:index, "Home page here")
      |> assign(:page_title, "Home Page")
      |> assign(:user_profile, user_profile)

    {:ok, socket}
  end
end

# if loaded?(user) do
#   # Access user data (e.g., user.email)
# else
#   # User data is not loaded, handle appropriately
# end
