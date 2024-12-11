defmodule TriviaWeb.ProfileLive.FormComponent do
  use TriviaWeb, :live_component

  alias Trivia.UserProfile

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage profile records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="profile-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:followers]}
          type="select"
          multiple
          label="Followers"
          options={[{"1", 1}, {"2", 2}]}
        />
        <.input
          field={@form[:followings]}
          type="select"
          multiple
          label="Followings"
          options={[{"1", 1}, {"2", 2}]}
        />
        <.input field={@form[:summary_is_public]} type="checkbox" label="Summary is public" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Profile</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{profile: profile} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(UserProfile.change_profile(profile))
     end)}
  end

  @impl true
  def handle_event("validate", %{"profile" => profile_params}, socket) do
    changeset = UserProfile.change_profile(socket.assigns.profile, profile_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"profile" => profile_params}, socket) do
    save_profile(socket, socket.assigns.action, profile_params)
  end

  defp save_profile(socket, :edit, profile_params) do
    case UserProfile.update_profile(socket.assigns.profile, profile_params) do
      {:ok, profile} ->
        notify_parent({:saved, profile})

        {:noreply,
         socket
         |> put_flash(:info, "Profile updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_profile(socket, :new, profile_params) do
    case UserProfile.create_profile(profile_params) do
      {:ok, profile} ->
        notify_parent({:saved, profile})

        {:noreply,
         socket
         |> put_flash(:info, "Profile created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
