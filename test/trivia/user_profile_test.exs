defmodule Trivia.UserProfileTest do
  use Trivia.DataCase

  alias Trivia.UserProfile

  describe "user_profile" do
    alias Trivia.UserProfile.Profile

    import Trivia.UserProfileFixtures

    @invalid_attrs %{arenas_joined: nil, games_played: nil, followers: nil, followings: nil, past_achievements: nil, past_summaries: nil, summary_is_public: nil}

    test "list_user_profile/0 returns all user_profile" do
      profile = profile_fixture()
      assert UserProfile.list_user_profile() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert UserProfile.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{arenas_joined: %{}, games_played: %{}, followers: [1, 2], followings: [1, 2], past_achievements: %{}, past_summaries: %{}, summary_is_public: true}

      assert {:ok, %Profile{} = profile} = UserProfile.create_profile(valid_attrs)
      assert profile.arenas_joined == %{}
      assert profile.games_played == %{}
      assert profile.followers == [1, 2]
      assert profile.followings == [1, 2]
      assert profile.past_achievements == %{}
      assert profile.past_summaries == %{}
      assert profile.summary_is_public == true
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserProfile.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{arenas_joined: %{}, games_played: %{}, followers: [1], followings: [1], past_achievements: %{}, past_summaries: %{}, summary_is_public: false}

      assert {:ok, %Profile{} = profile} = UserProfile.update_profile(profile, update_attrs)
      assert profile.arenas_joined == %{}
      assert profile.games_played == %{}
      assert profile.followers == [1]
      assert profile.followings == [1]
      assert profile.past_achievements == %{}
      assert profile.past_summaries == %{}
      assert profile.summary_is_public == false
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = UserProfile.update_profile(profile, @invalid_attrs)
      assert profile == UserProfile.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = UserProfile.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> UserProfile.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = UserProfile.change_profile(profile)
    end
  end
end
