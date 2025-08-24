defmodule SchoolPulseApi.RolesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SchoolPulseApi.Accounts` context.
  """

  alias SchoolPulseApi.Accounts.Role

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        name: "test_role"
      })
      |> SchoolPulseApi.Accounts.create_role()

    role
  end
end
