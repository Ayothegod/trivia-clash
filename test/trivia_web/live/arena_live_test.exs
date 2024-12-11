defmodule TriviaWeb.ArenaLiveTest do
  use TriviaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Trivia.ArenasFixtures

  @create_attrs %{public: true, is_player: true, players: ["option1", "option2"], arena_theme: %{}, no_of_players: 42, observer_capacity: 42}
  @update_attrs %{public: false, is_player: false, players: ["option1"], arena_theme: %{}, no_of_players: 43, observer_capacity: 43}
  @invalid_attrs %{public: false, is_player: false, players: [], arena_theme: nil, no_of_players: nil, observer_capacity: nil}

  defp create_arena(_) do
    arena = arena_fixture()
    %{arena: arena}
  end

  describe "Index" do
    setup [:create_arena]

    test "lists all arenas", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/arenas")

      assert html =~ "Listing Arenas"
    end

    test "saves new arena", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/arenas")

      assert index_live |> element("a", "New Arena") |> render_click() =~
               "New Arena"

      assert_patch(index_live, ~p"/arenas/new")

      assert index_live
             |> form("#arena-form", arena: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#arena-form", arena: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/arenas")

      html = render(index_live)
      assert html =~ "Arena created successfully"
    end

    test "updates arena in listing", %{conn: conn, arena: arena} do
      {:ok, index_live, _html} = live(conn, ~p"/arenas")

      assert index_live |> element("#arenas-#{arena.id} a", "Edit") |> render_click() =~
               "Edit Arena"

      assert_patch(index_live, ~p"/arenas/#{arena}/edit")

      assert index_live
             |> form("#arena-form", arena: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#arena-form", arena: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/arenas")

      html = render(index_live)
      assert html =~ "Arena updated successfully"
    end

    test "deletes arena in listing", %{conn: conn, arena: arena} do
      {:ok, index_live, _html} = live(conn, ~p"/arenas")

      assert index_live |> element("#arenas-#{arena.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#arenas-#{arena.id}")
    end
  end

  describe "Show" do
    setup [:create_arena]

    test "displays arena", %{conn: conn, arena: arena} do
      {:ok, _show_live, html} = live(conn, ~p"/arenas/#{arena}")

      assert html =~ "Show Arena"
    end

    test "updates arena within modal", %{conn: conn, arena: arena} do
      {:ok, show_live, _html} = live(conn, ~p"/arenas/#{arena}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Arena"

      assert_patch(show_live, ~p"/arenas/#{arena}/show/edit")

      assert show_live
             |> form("#arena-form", arena: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#arena-form", arena: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/arenas/#{arena}")

      html = render(show_live)
      assert html =~ "Arena updated successfully"
    end
  end
end
