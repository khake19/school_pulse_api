defmodule SchoolPulseApiWeb.Plugs.ActivityLogger do
  import Plug.Conn
  alias SchoolPulseApi.ActivityLogger

  @moduledoc """
  A plug that Logs activities after controller actions complete.
  """

  @config %{
    "TeacherController" => %{
      entity_type: :teacher,
      actions: [:created, :updated, :deleted],
      enabled: true
    },
    "SchoolController" => %{
      entity_type: :school,
      actions: [:created, :updated, :deleted],
      enabled: true
    },
    "DocumentController" => %{
      entity_type: :document,
      actions: [:created, :updated, :deleted],
      enabled: true
    },
    "LeaveController" => %{
      entity_type: :leave,
      actions: [:created, :updated, :deleted],
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

          if action_type in actions and conn.status in [200, 201] and conn.assigns[:account] do
            entity_id = get_entity_id(conn, entity_type)
            description = build_description(action_type, entity_type)

            ActivityLogger.log_activity(
              conn,
              action_type,
              entity_type,
              entity_id,
              description,
              %{controller: controller, action: action}
            )
          end

        _ ->
          :ok
      end

      conn
    end)
  end

  def get_action(conn) do
    case conn.method do
      "POST" -> :created
      "PUT" -> :updated
      "PATCH" -> :updated
      "DELETE" -> :deleted
      _ -> :other
    end
  end

  def get_controller_name(conn) do
    Phoenix.Controller.controller_module(conn)
    |> to_string()
    |> String.split(".")
    |> List.last()
  end

  defp get_entity_id(conn, entity_type) do
    case {conn.path_params, get_action(conn)} do
      {%{"id" => id}, _} -> id
      {_, :created} -> extract_id_from_response(conn, entity_type)
      _ -> nil
    end
  end

  def extract_id_from_response(conn, _entity_type) do
    case conn.resp_body do
      body when is_binary(body) ->
        case Jason.decode(body) do
          {:ok, %{"data" => %{"id" => id}}} -> id
          _ -> nil
        end

      iodata when is_list(iodata) ->
        # Convert iodata to binary and then parse JSON
        try do
          json_string = IO.iodata_to_binary(iodata)

          case Jason.decode(json_string) do
            {:ok, %{"data" => %{"id" => id}}} -> id
            _ -> nil
          end
        rescue
          _ -> nil
        end

      _ ->
        nil
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
