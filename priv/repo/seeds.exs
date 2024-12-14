defmodule Trivia.Seeds do
  # alias Trivia.Repo
  # alias Trivia.ArenaThemeContext.ArenaTheme

  def insert_default_themes do
    themes = [
      %{
        name: "Classic",
        description: "A timeless theme",
        color_scheme: %{"primary" => "#FFFFFF", "secondary" => "#000000"},
        status: true
      },
      %{
        name: "Futuristic",
        description: "A modern and sleek theme",
        color_scheme: %{"primary" => "#0000FF", "secondary" => "#00FF00"},
        status: true
      },
      %{
        name: "Dark Mode",
        description: "A dark theme for the night owls",
        color_scheme: %{"primary" => "#121212", "secondary" => "#BB86FC"},
        status: true
      },
      %{
        name: "Retro",
        description: "A theme from the past",
        color_scheme: %{"primary" => "#FF0000", "secondary" => "#FFFF00"},
        status: true
      },
      %{
        name: "Nature",
        description: "A calm and peaceful nature-inspired theme",
        color_scheme: %{"primary" => "#4CAF50", "secondary" => "#8BC34A"},
        status: true
      }
    ]

    IO.puts("Inserting default themes...")

    Enum.each(themes, fn theme_data ->
      IO.inspect(theme_data, label: "Inserting Theme")

      %Trivia.ArenaThemeContext.ArenaTheme{}
      |> Trivia.ArenaThemeContext.ArenaTheme.changeset(theme_data)
      |> Trivia.Repo.insert!()
    end)
  end
end

Trivia.Seeds.insert_default_themes()
