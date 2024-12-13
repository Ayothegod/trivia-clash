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

# <%= if @user do %>
# <div class="flex gap-1 items-center">
#   <.link phx-click="log_out">
#     <Button.button size="medium">
#       Log out
#     </Button.button>
#   </.link>

#   <Avatar.avatar color="primary">SB</Avatar.avatar>

#   <Dropdown.dropdown relative="relative">
#     <Dropdown.dropdown_trigger>
#       <Button.button color="brand" class="bg-brand text-white" icon="hero-chevron-down" size="small" right_icon>
#         Welcome User
#       </Button.button>
#     </Dropdown.dropdown_trigger>

#     <Dropdown.dropdown_content space="small" rounded="large" width="full" padding="extra_small" class="mt-2">
#       <ul :for={link <- @links}>
#         <.link navigate={link.url} class="flex gap-2 items-center group">
#           <.iconify icon={link.icon} class="group-hover:text-brand" />
#           <li class="group-hover:text-brand">{link.title}</li>
#         </.link>
#       </ul>
#     </Dropdown.dropdown_content>
#   </Dropdown.dropdown>
# </div>
# <% else %>
#   <div class="flex gap-2 items-center">
#     <.link href={~p"/users/log_in"}>
#       <Button.button size="medium">
#         Log In
#       </Button.button>
#     </.link>
#   </div>
#   <% end %>
# -
# -
# --
# -
# ---
# --

# --

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
