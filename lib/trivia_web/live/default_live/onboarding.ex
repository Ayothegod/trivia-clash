defmodule TriviaWeb.DefaultLive.Onboard do
  use TriviaWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    # Logger.critical(socket)
    # socket.assigns.current_user.id

    # changeset =
    #   User.registration_changeset(user, attrs, hash_password: false, validate_email: false)

    socket =
      socket
      |> assign(:page_title, "Onboard Page")
      |> assign(:logoUrl, "/")

    # |> assign_form(changeset)

    # |> assign(trigger_submit: false, check_errors: false)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  # def change_user_registration(%User{} = user, attrs \\ %{}) do
  #   User.registration_changeset(user, attrs, hash_password: false, validate_email: false)
  # end

  # defp assign_form(socket, %Ecto.Changeset{} = changeset) do
  #   form = to_form(changeset, as: "profile")

  #   if changeset.valid? do
  #     assign(socket, form: form, check_errors: false)
  #   else
  #     assign(socket, form: form)
  #   end
  # end
end

# i created a custom component, and im collecting url from html
# <Logo.logo url={@logoUrl} />
# this is how i passed it
# socket =
# socket
# |> assign(:page_title, "Onboard Page")
# |> assign(:logoUrl, "/")

# how do i use it as a url
# <.link navigate={~p{@url}}>
#   <h2 class="text-2xl font-bol text-brand">
#     Hello World, from from Logo
#   </h2>
# </.link>
