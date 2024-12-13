defmodule TriviaWeb.DefaultLive.Onboard do
  use TriviaWeb, :live_view
  require Logger

  alias Trivia.UserProfile.Profile
  alias Trivia.UserProfile
  # alias Trivia.Accounts.User
  # alias TriviaWeb.SharedData

  @impl true
  @spec mount(any(), any(), map()) :: {:ok, map(), [{:temporary_assigns, [...]}, ...]}
  def mount(_params, _session, socket) do
    changeset = Profile.changeset(%Profile{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)
      |> assign(:page_title, "Onboard Page")
      |> assign(:user, nil)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user_profile" => user_params}, socket) do
    user_id = socket.assigns.current_user.id
    params = Map.put(user_params, "user_id", user_id)

    IO.inspect(user_params, label: "params")
    IO.inspect(params, label: "params")

    profile = UserProfile.create_profile(params)

    case profile do
      {:ok, profile} ->
        socket =
          socket |> assign(profile: profile)

        changeset = Profile.createProfile(%Profile{}, user_params)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user_profile" => user_params}, socket) do
    changeset = Profile.createProfile(%Profile{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user_profile")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end

# -
# -
# -
# -
# -
# -
# -
# --

# -
# -
# -
# -
# -

# -
# -
# -

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
