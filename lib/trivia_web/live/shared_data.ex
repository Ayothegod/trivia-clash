defmodule TriviaWeb.SharedData do
  use TriviaWeb, :controller
  alias Trivia.Accounts

  def links() do
    [
      %{id: 1, title: "Profile", url: "onboarding", icon: "heroicons:rectangle-stack-16-solid"},
      %{id: 2, title: "Settings", url: "onboarding", icon: "heroicons:rectangle-stack-16-solid"},
      %{id: 3, title: "Log out", url: "onboarding", icon: "heroicons:rectangle-stack-16-solid"}
    ]
  end

  def profile(socket, _session) do
    id = socket.assigns.current_user.id
    profile = Accounts.get_user!(id)
  end
end

# id = conn.assigns.current_user.id
# profile = Accounts.get_user!(id)
