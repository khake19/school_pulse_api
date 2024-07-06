defmodule SchoolPulseApi.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SchoolPulseApi.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        email: unique_user_email()
      })
      |> SchoolPulseApi.Accounts.create_user()

    user
  end

  @doc """
  Generate a document.
  """
  def document_fixture(attrs \\ %{}) do
    {:ok, document} =
      attrs
      |> Enum.into(%{

      })
      |> SchoolPulseApi.Accounts.create_document()

    document
  end
end
