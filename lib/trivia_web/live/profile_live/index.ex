defmodule TriviaWeb.ProfileLive.Index do
  use TriviaWeb, :live_view
  require Logger

  alias Trivia.UserProfile
  alias Trivia.UserProfile.Profile
  alias TriviaWeb.SharedData

  @impl true
  def mount(_params, _session, socket) do
    links = SharedData.links()

    socket =
      case SharedData.profile(socket) do
        {:ok, %{user: userData}} ->
          IO.inspect(userData, label: "User data")
          assign(socket, :user, userData)

        {:error, :not_found} ->
          Logger.error("User not found!")
          redirect(socket, to: "/users/logout_redirect")

        {:error, :unauthenticated} ->
          Logger.error("User is unauthenticated!")
          redirect(socket, to: "/users/log_in")
      end

    socket =
      socket
      |> assign(:page_title, "Profile Page")
      |> assign(:links, links)

    # IO.inspect(user_profile, label: "User profiles")

    user_profile = UserProfile.list_user_profile()
    {:ok, stream(socket, :user_profile, user_profile)}
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
