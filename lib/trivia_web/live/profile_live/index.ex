defmodule TriviaWeb.ProfileLive.Index do
  use TriviaWeb, :live_view

  alias Trivia.UserProfile
  alias Trivia.UserProfile.Profile

  @impl true
  def mount(_params, session, socket) do
    profile = session["user_profile"]

    allProfiles = UserProfile.list_user_profile()
    IO.inspect(allProfiles, label: "ALl User profile")

    socket =
      socket
      |> assign(:profile, profile)
      |> assign(:user_profile, allProfiles)

    # |> stream(:user_profile, UserProfile.list_user_profile())

    # stream(:user_profile, UserProfile.list_user_profile())
    # {:ok, stream(socket, :user_profile, UserProfile.list_user_profile())}
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Profile")
    |> assign(:profile, UserProfile.get_profile!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Profile")
    |> assign(:profile, %Profile{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User profile")
    |> assign(:profile, nil)
  end

  @impl true
  def handle_info({TriviaWeb.ProfileLive.FormComponent, {:saved, profile}}, socket) do
    {:noreply, stream_insert(socket, :user_profile, profile)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    profile = UserProfile.get_profile!(id)
    {:ok, _} = UserProfile.delete_profile(profile)

    {:noreply, stream_delete(socket, :user_profile, profile)}
  end
end

# # Assuming you have a user with ID 1
# user = Repo.get!(Trivia.Accounts.User, 1)

# %Trivia.Accounts.UserProfile{}
# |> Ecto.Changeset.cast(%{
#   arenas_joined: ["Arena 1", "Arena 2"],
#   games_played: ["Game 1", "Game 2"],
#   followers: ["User 2", "User 3"],
#   followings: ["User 4", "User 5"],
#   past_achievements: ["First Place in Arena 1"],
#   past_summaries: ["Great game!"],
#   summary_is_public: true
# }, [:arenas_joined, :games_played, :followers, :followings, :past_achievements, :past_summaries, :summary_is_public])
# |> Ecto.Changeset.put_assoc(:user, user)
# |> Repo.insert()
