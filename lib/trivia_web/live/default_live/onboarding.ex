defmodule TriviaWeb.DefaultLive.Onboard do
  use TriviaWeb, :live_view
  require Logger

  alias Trivia.UserProfile.Profile
  alias Trivia.UserProfile
  # alias Trivia.Accounts.User

  alias TriviaWeb.SharedData

  @impl true
  def mount(_params, _session, socket) do
    changeset = Profile.changeset(%Profile{})
    links = SharedData.links()

    socket =
      case SharedData.profile(socket) do
        {:ok, %{user: userData}} ->
          IO.inspect(userData.email, label: "User Email")
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
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)
      |> assign(:page_title, "Onboard Page")
      |> assign(:links, links)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user_profile" => user_params}, socket) do
    user_id = socket.assigns.current_user.id
    params = Map.put(user_params, "user_id", user_id)

    profile = UserProfile.create_profile(params)

    case profile do
      {:ok, profile} ->
        socket =
          socket |> assign(profile: profile)

        changeset = Profile.changeset(profile)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user_profile")

    if changeset.valid? do
      assign(socket, form: form)
    else
      assign(socket, form: form)
    end
  end
end
