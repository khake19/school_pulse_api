defmodule SchoolPulseApi.Schools.Policy do
  @behaviour Bodyguard.Policy

  alias SchoolPulseApi.Accounts.User
  alias SchoolPulseApi.Schools.School

  # Admins can access all schools and count
  def authorize(action, %User{role: %{name: "admin"}}, _school) when action in [:view, :count],
    do: true

  # School admins can view and count for schools they belong to
  def authorize(action, %User{role: %{name: "school admin"}} = current_user, %School{
        id: school_id
      })
      when action in [:view, :count] do
    Enum.any?(current_user.schools, fn s -> s.id == school_id end)
  end

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
