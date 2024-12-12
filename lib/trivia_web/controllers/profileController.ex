defmodule TriviaWeb.OnboardController do
  use TriviaWeb, :controller

  require Logger
  alias Trivia.Accounts

  def create(conn, %{"_action" => "onboard"} = params) do
    conn
    |> create(params, "Your profile has been updated successfully!")
  end

  defp create(conn, %{"user_profile" => user_params}, info) do
    id = conn.assigns.current_user.id
    profile = Accounts.get_user!(id)

    if user_params do
      conn
      |> put_session(:user_profile, profile)
      |> put_flash(:info, info)
      |> redirect(to: ~p"/")
    else
      conn
      |> put_session(:user_profile, profile)
      |> put_flash(:error, "Unable to update profile, try again later.")
      |> redirect(to: ~p"/user_profile")
    end
  end
end
