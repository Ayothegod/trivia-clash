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

# <p>Hello, <%= @user_name %></p>

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

# <.form for={@form} phx-submit="save">
#   <.input field={@form[:name]} type="text" label="Name" />
#   <.input field={@form[:email]} type="email" label="Email" />
#   <button>Submit</button>
# </.form>

# <a href={Routes.user_show_path(@socket, :show, user_id: @user.id)}>View Profile</a>

# <.my_component name={@user_name} />

# <%!-- <.link navigate={~p"/onboarding"}>Onboard</.link>
#   <.link navigate={Routes.user_path(@socket, :index, id: link.url)} class="flex gap-2 items-center group">
#     <.iconify icon="heroicons:rectangle-stack-16-solid" class="w-8 h-8 text-base-content cursor-pointer text-brand" />
#     <.iconify icon={@icon} />
#     <ul>
#       <li>Email: <%= @profile.user.email %>
#       </li>
#     </ul>
#     --%>

# <Dropdown.dropdown relative="relative" clickable>
# <Dropdown.dropdown_trigger trigger_id="unique_id">
#   <Avatar.avatar color="primary">SB</Avatar.avatar>
# </Dropdown.dropdown_trigger>

# <Dropdown.dropdown_content id="unique_id" space="small" rounded="large" width="w-96" padding="extra_small"
#   class="w-36 bg-red-600 mt-2">
#   <ul :for={link <- @links}>
#     <.link navigate={~p"/#{link.url}"} class="flex gap-2 items-center group">
#       <.iconify icon={link.icon} class="group-hover:text-brand" />
#       <li class="group-hover:text-brand">{link.title}</li>
#     </.link>
#   </ul>
# </Dropdown.dropdown_content>
# </Dropdown.dropdown>
