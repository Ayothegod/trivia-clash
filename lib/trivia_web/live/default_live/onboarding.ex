defmodule TriviaWeb.DefaultLive.Onboard do
  use TriviaWeb, :live_view
  require Logger

  alias Trivia.UserProfile.Profile
  alias Trivia.UserProfile

  @impl true
  def mount(_params, _session, socket) do
    # socket.assigns.current_user.id
    changeset = Profile.changeset(%Profile{})

    socket =
      socket
      |> assign(:page_title, "Onboard Page")
      |> assign(:logoUrl, "/")
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user_profile" => user_params}, socket) do
    user_id = socket.assigns.current_user.id
    params = Map.put(user_params, "user_id", user_id)
    profile = UserProfile.create_profile(params)
    IO.inspect(profile, label: "New_profile")

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

# case Accounts.register_user(user_params) do
#   {:ok, user} ->
#     # changeset = Accounts.change_user_registration(user)
#     {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

#   {:error, %Ecto.Changeset{} = changeset} ->
#     {:noreply, socket |> assign_form(changeset)}
# end
#
#
#
#
#
#
#

# def onboard_changeset(user, attrs, opts \\ []) do
#   user
#   |> cast(attrs, [:email, :password])
#   |> validate_email(opts)
#   |> validate_password(opts)
# end

# def registration_changeset(user, attrs, opts \\ []) do
#   user
#   |> cast(attrs, [:email, :password])
#   |> validate_email(opts)
#   |> validate_password(opts)
# end

# defp validate_email(changeset, opts) do
#   changeset
#   |> validate_required([:email])
#   |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
#   |> validate_length(:email, max: 160)
#   |> maybe_validate_unique_email(opts)
# end

# defp validate_password(changeset, opts) do
#   changeset
#   |> validate_required([:password])
#   |> validate_length(:password, min: 12, max: 72)
#   |> maybe_hash_password(opts)
# end