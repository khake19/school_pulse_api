defmodule SchoolPulseApiWeb.Plugs.ActivityLogger do

  import Plug.Conn
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
        %{entity_type: entity, actions: actions, enabled: true} ->
        _->
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
end
