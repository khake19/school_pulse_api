defmodule SchoolPulseApiWeb.AuthJSON do
  def account_token(%{account: account, token: token}) do
    %{
      id: account.id,
      email: account.email,
      token: token
    }
  end

  def me(%{current_user: current_user}) do
    %{
      data: %{
        id: current_user.id,
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        gender: current_user.gender,
        email: current_user.email,
        avatar: current_user.avatar,
        role: %{
          id: current_user.role.id,
          name: current_user.role.name,
          description: current_user.role.description
        },
        inserted_at: current_user.inserted_at,
        updated_at: current_user.updated_at
      }
    }
  end
end
