defmodule SchoolPulseApi.TeachersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SchoolPulseApi.Teachers` context.
  """

  @doc """
  Generate a teacher.
  """
  def teacher_fixture(attrs \\ %{}) do
    {:ok, teacher} =
      attrs
      |> Enum.into(%{
        position: "some position"
      })
      |> SchoolPulseApi.Teachers.create_teacher()

    teacher
  end
end
