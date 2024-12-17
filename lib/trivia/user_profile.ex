defmodule Trivia.UserProfile do
  @moduledoc """
  The UserProfile context.
  """

  import Ecto.Query, warn: false
  alias Trivia.Repo

  alias Trivia.UserProfile.Profile

  def list_user_profile do
    Repo.all(Profile)
  end

  def get_profile!(id) do
    query =
      from p in Profile,
        preload: [:user],
        where: p.id == ^id,
        select: %{profile: p}

    Repo.one!(query)
  end

  def create_profile(params) do
    changeset = Profile.createProfile(%Profile{}, params)
    Repo.insert(changeset)
  end

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
