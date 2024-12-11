defmodule TriviaWeb.ProfileLiveTest do
  use TriviaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Trivia.UserProfileFixtures

  @create_attrs %{arenas_joined: %{}, games_played: %{}, followers: [1, 2], followings: [1, 2], past_achievements: %{}, past_summaries: %{}, summary_is_public: true}
  @update_attrs %{arenas_joined: %{}, games_played: %{}, followers: [1], followings: [1], past_achievements: %{}, past_summaries: %{}, summary_is_public: false}
  @invalid_attrs %{arenas_joined: nil, games_played: nil, followers: [], followings: [], past_achievements: nil, past_summaries: nil, summary_is_public: false}

  defp create_profile(_) do
    profile = profile_fixture()
    %{profile: profile}
  end

  describe "Index" do
    setup [:create_profile]

    test "lists all user_profile", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/user_profile")

      assert html =~ "Listing User profile"
    end

    test "saves new profile", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/user_profile")

      assert index_live |> element("a", "New Profile") |> render_click() =~
               "New Profile"

      assert_patch(index_live, ~p"/user_profile/new")

      assert index_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#profile-form", profile: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_profile")

      html = render(index_live)
      assert html =~ "Profile created successfully"
    end

    test "updates profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, ~p"/user_profile")

      assert index_live |> element("#user_profile-#{profile.id} a", "Edit") |> render_click() =~
               "Edit Profile"

      assert_patch(index_live, ~p"/user_profile/#{profile}/edit")

      assert index_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#profile-form", profile: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_profile")

      html = render(index_live)
      assert html =~ "Profile updated successfully"
    end

    test "deletes profile in listing", %{conn: conn, profile: profile} do
      {:ok, index_live, _html} = live(conn, ~p"/user_profile")

      assert index_live |> element("#user_profile-#{profile.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_profile-#{profile.id}")
    end
  end

  describe "Show" do
    setup [:create_profile]

    test "displays profile", %{conn: conn, profile: profile} do
      {:ok, _show_live, html} = live(conn, ~p"/user_profile/#{profile}")

      assert html =~ "Show Profile"
    end

    test "updates profile within modal", %{conn: conn, profile: profile} do
      {:ok, show_live, _html} = live(conn, ~p"/user_profile/#{profile}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Profile"

      assert_patch(show_live, ~p"/user_profile/#{profile}/show/edit")

      assert show_live
             |> form("#profile-form", profile: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#profile-form", profile: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_profile/#{profile}")

      html = render(show_live)
      assert html =~ "Profile updated successfully"
    end
  end
end
