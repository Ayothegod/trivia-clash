defmodule TriviaWeb.Router do
  use TriviaWeb, :router

  import TriviaWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TriviaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # plug TriviaWeb.RouteCheckPlug
  # plug TriviaWeb.UserAssignPlug

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:trivia, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TriviaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", TriviaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TriviaWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", TriviaWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{TriviaWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/", DefaultLive.Index, :index
      live "/onboarding", DefaultLive.Onboard, :index

      # NOTE: arenas
      live "/arenas", ArenaLive.Index, :index
      live "/arenas/new", ArenaLive.Index, :new
      live "/arenas/:id/edit", ArenaLive.Index, :edit
      live "/arenas/:id", ArenaLive.Show, :show
      live "/arenas/:id/show/edit", ArenaLive.Show, :edit

      # TODO: profile
      live "/profile", ProfileLive.Index, :index
      live "/user_profile/new", ProfileLive.Index, :new
      live "/user_profile/:id/edit", ProfileLive.Index, :edit

      live "/user_profile/:id", ProfileLive.Show, :show
      live "/user_profile/:id/show/edit", ProfileLive.Show, :edit
    end

    post "/profile/update", OnboardController, :create
  end

  scope "/", TriviaWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/logout_redirect", UserSessionController, :logout_redirect

    live_session :current_user,
      on_mount: [{TriviaWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end

# DONE: basic heex rendering templates
# <p>Hello, <%= @user_name %></p>
# <p>Fullname: <%= @user.user_profile.fullname || "Hello" %></p>
# <p>Fullname: <%= if @user.user_profile.fullname, do: @user.user_profile.fullname, else: "Hello" %></p>

# NOTE: basic logic template rendering
# <% if @is_admin %>
#   <p>You are an admin.</p>
# <% else %>
#   <p>You are a regular user.</p>
# <% end %>

# <ul>
#   <%= for item <- @items do %>
#     <li><%= item %></li>
#   <% end %>
# </ul>

# <%= case @user.user_profile.fullname do %>
#   <% nil -> %>
#     <p>Fullname: Hello</p>
#   <% fullname -> %>
#     <p>Fullname: <%= fullname %></p>
# <% end %>

# <.form for={@form} phx-submit="save">
#   <.input field={@form[:name]} type="text" label="Name" />
#   <.input field={@form[:email]} type="email" label="Email" />
#   <button>Submit</button>
# </.form>

# <a href={Routes.user_show_path(@socket, :show, user_id: @user.id)}>View Profile</a>
# <.my_component name={@user_name} />
#   <.link navigate={Routes.user_path(@socket, :index, id: link.url)} class="flex gap-2 items-center group">
#     <.iconify icon={@icon} />

# NOTE: start up a new task in the same process
# Task.start(fn -> send_metrics_to_service(data) end)

# NOTE: action functions
# Use handle_event/3 for interactive events triggered by the user.
# Use handle_params/3 for responding to changes in the URL or query string.
# Use handle_info/2 for handling asynchronous updates or background processes.
# Use mount/3 for initializing the LiveView state.

# DONE: connected lifecycle -> updating data by passing action to handle_info
# def mount(_params, _session, socket) do
#   if connected?(socket) do
#     send(self(), :load_data)
#   end
#   {:ok, assign(socket, data: nil)}
#     {:ok, assign(socket, data: nil, loading: true)}
# end
# def handle_info(:load_data, socket) do
#   data = fetch_data_somehow()
#   {:noreply, assign(socket, data: data)}
# end
# DONE:  work with connected and return data whe its true (if..else, case)
# def mount(_params, _session, socket) do
#   socket =
#     if connected?(socket) do
#       data = Post.get_posts() # Fetch posts only if connected
#       assign(socket, :data, data)
#     else
#       assign(socket, :data, nil) # Assign nil initially
#     end
#   {:ok, socket}
# end
# def mount(_params, _session, socket) do
#   socket =
#     case connected?(socket) do
#       true ->
#         data = Post.get_posts() # Fetch posts only if connected
#         assign(socket, :data, data)
#       false ->
#         assign(socket, :data, nil) # Assign nil initially
#     end

#   {:ok, socket}
# end
# PENDING: using connected? data
# <%= if @data do %>
#   <p><%= @data.some_value %></p>
# <% else %>
#   <p>Loading...</p>
# <% end %>

# also this ->
#   {:ok, assign(socket, data: %{})}
#   <p><%= @data.some_value || "Default Value" %></p>

#   <%= case @data do %>
#   <% nil -> %>
#     <p>Loading data...</p>
#   <% data -> %>
#     <p>Data: <%= data.some_value %></p>
# <% end %>

# <div id="data-container">
#   <%= if @data do %>
#     <p>Data: <%= @data.some_value %></p>
#   <% else %>
#     <p>Loading...</p>
#   <% end %>
# </div>
