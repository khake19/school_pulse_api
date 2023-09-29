defmodule SchoolPulseApi.SchoolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SchoolPulseApi.Schools` context.
  """

  @doc """
  Generate a school.
  """
  def school_fixture(attrs \\ %{}) do
    {:ok, school} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SchoolPulseApi.Schools.create_school()

    school
  end
end
