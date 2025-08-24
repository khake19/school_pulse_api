defmodule SchoolPulseApi.Schools.Policy do
  @behaviour Bodyguard.Policy

  alias SchoolPulseApi.Accounts.User
  alias SchoolPulseApi.Schools.School

  # Admins can access all schools and count
  def authorize(action, %User{role_id: 1}, _school) when action in [:view, :count], do: true

  # School admins can view and count for schools they belong to
  def authorize(action, %User{role_id: 2} = user, %School{} = school) when action in [:view] do
    user.id in Enum.map(school.users, & &1.id)
  end

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
