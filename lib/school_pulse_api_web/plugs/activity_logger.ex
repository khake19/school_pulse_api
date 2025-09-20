defmodule SchoolPulseApiWeb.Plugs.ActivityLogger do

  import Plug.Conn
  alias SchoolPulseApi.ActivityLogger

  @moduledoc """
  A plug that Logs activities after controller actions complete.
  """

  @config %{
    "TeacherController" => %{
      entity_type: :teacher,
      actions: [:create, :update, :delete],
      enabled: true
    }, 
    "SchoolController" => %{
      entity_type: :school,
      actions: [:create, :update, :delete],
      enabled: true
    }, 
    "DocumentController" => %{
      entity_type: :document,
      actions: [:create, :update, :delete],
      enabled: true
    }, 
    "LeaveController" => %{
      entity_type: :leave,
      actions: [:create, :update, :delete],
      enabled: false
    } 
  }

  def init(opts), do: opts


  def call(conn, _opts) do

    register_before_send(conn, fn conn ->
      controller = get_controller_name(conn)
      action = Phoenix.Controller.action_name(conn)

      case Map.get(@config, controller) do
        %{entity_type: entity_type, actions: actions, enabled: true} ->
          action_type = get_action(conn)

          if action_type in actions and conn.status in [200, 201] and conn.assigns[:current_user] do
            entity_id = get_entity_id(conn, entity_type)
            description = build_description(action_type, entity_type)

            ActivityLogger.log_activity(
              conn,
              action_type,
              entity_type,
              entity_id,
              description,
              %{controller: controller, action: Phoenix.Controller.action_name(conn)}
            )
          end
        _ ->
          :ok
      end

      conn
    end)
  end

  # defp should_log?(conn) do
  #   # config.enabled && conn.assigns[:current_user] &&
  #   # conn.status in [200, 201] &&
  #   # get_controller_name(conn) &&
  #   # get_action(conn) in config.actions
  # end

  def get_action(conn) do
    case conn.method do
      "POST" -> :create
      "PUT" -> :update
      "PATCH" -> :update
      "DELETE" -> :delete
      _ -> :other
    end
  end

  def get_controller_name(conn) do
    Phoenix.Controller.controller_module(conn)
    |> to_string()
    |> String.split(".")
    |> List.last()
  end

  defp get_entity_id(conn, _entity_type) do
    case conn.path_params do
      %{"id" => id} -> id
      _ -> nil
    end
  end

  defp build_description(action_type, entity_type) do
    case action_type do
      :created -> "Created #{entity_type}"
      :updated -> "Updated #{entity_type}"
      :deleted -> "Deleted #{entity_type}"
      _ -> "Performed #{action_type} on #{entity_type}"
    end
  end
end
