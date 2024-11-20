defmodule ReportGenerator do
  defp replace_placeholders_in_row(row, data) do
    Enum.map(row, fn cell -> replace_placeholder(cell, data) end)
  end

  defp replace_placeholder(%{"value" => value, "type" => "variable"}, data) do
    # Extract key from the value string (e.g., "%{id}")
    [_, key] = Regex.run(~r/%\{(.+)\}/, value)

    # Fetch the corresponding value from the data map
    Map.get(data, String.to_atom(key))
  end

  defp replace_placeholder(cell, _data) do
    # For headers and non-variable cells, just return the value as is
    cell["value"]
  end

  # Main function to process each row for the entire dataset
  def generate_sheet_data(template, data_list) do
    # Generate headers (no placeholder replacement needed)
    headers = Enum.at(template["rows"], 0)

    # Generate rows with data for each entry in data_list
    rows =
      Enum.map(data_list, fn data ->
        # For each data entry, replace placeholders in the row template
        row_template = Enum.at(template["rows"], 1)
        replace_placeholders_in_row(row_template, data)
      end)

    # Add headers at the beginning of the sheet
    [replace_placeholders_in_row(headers, %{}) | rows]
  end
end