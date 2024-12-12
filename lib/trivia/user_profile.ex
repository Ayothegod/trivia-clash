defmodule Trivia.UserProfile do
  @moduledoc """
  The UserProfile context.
  """

  import Ecto.Query, warn: false
  alias Trivia.Repo

  alias Trivia.UserProfile.Profile
  # alias Trivia.Accounts.User

  @doc """
  Returns the list of user_profile.

  ## Examples

      iex> list_user_profile()
      [%Profile{}, ...]

  """
  def list_user_profile do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_profile!(id) do
  #   #     SELECT p.*, u.email, u.username
  #   # FROM user_profiles p
  #   # JOIN users u ON p.user_id = u.id;

  #   query =
  #     from p in UserProfile,
  #       join: u in User,
  #       on: p.user_id == u.id,
  #       select: %{profile: p, user: u}

  #   query2 =
  #     select * from UserProfile where:,
  #       join: u in User,
  #       on: p.user_id == u.id,
  #       select: %{profile: p, user: u}

  #   results = Repo.all(query)

  #   Repo.get!(Profile, id)
  # end

  def get_profile!(id) do
    query =
      from p in Profile,
        preload: [:user],
        where: p.id == ^id,
        select: %{profile: p}

    Repo.one!(query)
  end

  # def test do
  #   query =
  #     from p in Profile,
  #       join: u in User,
  #       on: p.user_id == u.id,
  #       where: p.id == ^id,
  #       select: %{profile: p, user: u}
  # end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_profile(params) do
    changeset = Profile.changeset(%Profile{}, params)
    Repo.insert(changeset)
  end

  # INSERT INTO "user_profile" ("arenas_joined","games_played","followers","followings","past_achievements","past_summaries","summary_is_public","user_id","bio","inserted_at","updated_at") VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING "id" [[], [], [], [], [], [], true, 13, "Just a chill guy! eh", ~U[2024-12-12 04:22:49Z], ~U[2024-12-12 04:22:49Z]]

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end
end
