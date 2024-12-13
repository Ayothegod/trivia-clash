defmodule TriviaWeb.SharedData do
  use TriviaWeb, :controller
  alias Trivia.Accounts

  def links() do
    [
      %{id: 1, title: "Home", url: "/", icon: "heroicons:rectangle-stack-16-solid"},
      %{id: 2, title: "Profile", url: "/profile", icon: "heroicons:rectangle-stack-16-solid"},
      %{id: 3, title: "Settings", url: "/onboarding", icon: "heroicons:rectangle-stack-16-solid"},
      %{id: 4, title: "Log out", url: "/onboarding", icon: "heroicons:rectangle-stack-16-solid"},
      %{
        id: 5,
        title: "Onboarding",
        url: "/onboarding",
        icon: "heroicons:rectangle-stack-16-solid"
      }
    ]
  end

  def profile(socket) do
    case socket.assigns do
      %{current_user: %{id: id}} ->
        case Accounts.get_user!(id) do
          nil ->
            {:error, :not_found}

          user ->
            {:ok, user}
        end

      _ ->
        {:error, :unauthenticated}
    end
  end
end

# if user.user.user_profile == nil do
#   IO.inspect("no profile")
#   {:error, :not_found}
# else
#   IO.inspect(user.user.user_profile)
#   {:ok, user}
# end
