defmodule SchoolPulseApi.Schools.Policy do
  @behaviour Bodyguard.Policy

  alias SchoolPulseApi.Accounts.User
  alias SchoolPulseApi.Schools.School

  # Admins can access all schools
  def authorize(:view, %User{role_id: 1}, _school), do: true

  def authorize(:view, %User{role_id: 2} = user, %School{} = school) do
    user.id in Enum.map(school.users, & &1.id)
  end

  # Catch-all: deny everything else
  def authorize(:view, _, _), do: false
end
