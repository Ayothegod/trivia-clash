defmodule TriviaWeb.ArenaLive.FormComponent do
  use TriviaWeb, :live_component

  alias Trivia.Arenas

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage arena records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="arena-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:is_player]} type="checkbox" label="Is player" />
        <.input
          field={@form[:players]}
          type="select"
          multiple
          label="Players"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input field={@form[:public]} type="checkbox" label="Public" />
        <.input field={@form[:no_of_players]} type="number" label="No of players" />
        <.input field={@form[:observer_capacity]} type="number" label="Observer capacity" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Arena</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{arena: arena} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Arenas.change_arena(arena))
     end)}
  end

  @impl true
  def handle_event("validate", %{"arena" => arena_params}, socket) do
    changeset = Arenas.change_arena(socket.assigns.arena, arena_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"arena" => arena_params}, socket) do
    save_arena(socket, socket.assigns.action, arena_params)
  end

  defp save_arena(socket, :edit, arena_params) do
    case Arenas.update_arena(socket.assigns.arena, arena_params) do
      {:ok, arena} ->
        notify_parent({:saved, arena})

        {:noreply,
         socket
         |> put_flash(:info, "Arena updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_arena(socket, :new, arena_params) do
    case Arenas.create_arena(arena_params) do
      {:ok, arena} ->
        notify_parent({:saved, arena})

        {:noreply,
         socket
         |> put_flash(:info, "Arena created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
