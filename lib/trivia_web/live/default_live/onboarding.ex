defmodule TriviaWeb.DefaultLive.Onboard do
  use TriviaWeb, :live_view
  require Logger

  alias Trivia.UserProfile.Profile
  alias Trivia.UserProfile

  alias TriviaWeb.SharedData

  @impl true
  def mount(_params, session, socket) do
    changeset = Profile.changeset(%Profile{})

    links = SharedData.links()
    profile = TriviaWeb.SharedData.profile(socket, session)
    IO.inspect(socket, label: "passed shared")
    IO.inspect(profile, label: "shared profile")
    IO.inspect(links, label: "shared links")

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)
      |> assign(:page_title, "Onboard Page")

    # |> assign(:profile, profile)

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
