defmodule SchoolPulseApi.LeavesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SchoolPulseApi.Leaves` context.
  """

  @doc """
  Generate a leave.
  """
  def leave_fixture(attrs \\ %{}) do
    {:ok, leave} =
      attrs
      |> Enum.into(%{
        type: "some type",
        remarks: "some remarks"
      })
      |> SchoolPulseApi.Leaves.create_leave()

    leave
  end
end
