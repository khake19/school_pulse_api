defmodule SchoolPulseApiWeb.SharedJSON do
  @moduledoc """
  Shared JSON utilities for controllers.
  """

  @doc """
  Converts Flop metadata to a consistent format for API responses.
  This function standardizes pagination metadata across all endpoints.
  """
  def meta_data(meta) do
    %{
      current_page: meta.current_page,
      current_offset: meta.current_offset,
      size: meta.page_size,
      total: meta.total_count,
      pages: meta.total_pages
    }
  end

  @doc """
  Creates a standard paginated response structure.
  """
  def paginated_response(data, meta) do
    %{data: data}
    |> Map.put(:meta, meta_data(meta))
  end

  @doc """
  Creates a standard error response structure.
  """
  def error_response(message, code \\ "error") do
    %{error: %{message: message}}
    |> Map.put_in([:error, :code], code)
  end

  @doc """
  Creates a standard success response structure.
  """
  def success_response(data, message \\ "Success") do
    %{data: data}
    |> Map.put(:message, message)
  end
end
