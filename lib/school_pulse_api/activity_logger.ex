defmodule SchoolPulseApi.ActivityLogger do
  @moduledoc """
  A convenience module for logging activities throughout the application
  """

  alias SchoolPulseApi.Activities

  @doc """
  Logs a user activity with automatic context extraction

  iex> log_activity(conn, :created, :teacher, teacher_id, "Created new teacher", %{name: "John Doe"})
  """

  def log_activity(conn, activity_type, entity_type, entity_id, description, metadata \\ %{}) do
    attrs = %{
      activity_type: activity_type,
      entity_type: entity_type,
      entity_id: entity_id,
      description: description,
      metadata: metadata
    }


    Activity.create_activity_with_context(conn, attrs)
  end
end
