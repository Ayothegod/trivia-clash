defmodule TriviaWeb.Components.Utils.Logo do
  use TriviaWeb, :live_view

  def logo(assigns) do
    ~H"""
    <.link navigate={~p"/#{@url}"}>
      <h2 class="text-xl font-bold text-brand">
        Trivia-Clash
      </h2>
    </.link>
    """
  end
end
