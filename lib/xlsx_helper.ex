defmodule SchoolPulseApi.Utils.XLSXHelper do

  alias Elixlsx.{Sheet, Workbook}

  @doc """
  Generates an XLSX file from a list of arrays (rows of data) and saves it to the specified file path.

  - `sheet_data` is a list of maps where each map represents a sheet.
  - Each sheet can contain:
    - `:name` - the name of the sheet.
    - `:rows` - a list of rows where each row is a list of cell values.
    - `:col_widths` (optional) - a map of column widths.
    - `:row_heights` (optional) - a map of row heights.
  """
  def generate_xlsx(sheet_data, file_name) do
    sheets = Enum.map(sheet_data, &create_sheet_from_rows/1)
    workbook = %Workbook{sheets: sheets}
    Elixlsx.write_to(workbook, file_name)
  end

  # Create a sheet from a list of rows and optional configurations
  defp create_sheet_from_rows(%{
      name: name,
      rows: rows,
      col_widths: col_widths,
      row_heights: row_heights
    }) do
    sheet = %Sheet{name: name, rows: rows}

    # Set column widths if provided
    sheet = Enum.reduce(col_widths || %{}, sheet, fn {col, width}, acc ->
      Sheet.set_col_width(acc, col, width)
    end)

    # Set row heights if provided
    Enum.reduce(row_heights || %{}, sheet, fn {row, height}, acc ->
      Sheet.set_row_height(acc, row, height)
    end)
  end
end


# sheet_data = [
#   %{
#     name: "Sheet1",
#     rows: [
#       [
#         ["NO.", bottom: [color: "#cc3311"]],
#         ["SCHOOL ID.", bottom: [color: "#cc3311"]],
#       ],
#       ["Alice", 30, "New York"],
#       ["Bob", 25, "Los Angeles"],
#       ["Charlie", 35, "Chicago"],
#       [1, 2, 3],
#     [4, 5, 6, ["goat", bold: true]],
#     [
#       ["Bold", bold: true],
#       ["Italic", italic: true],
#       ["Underline", underline: true],
#       ["Strike!", strike: true],
#       ["Large", size: 22]
#     ],
#     # wrap_text makes text wrap, but it does not increase the row height
#     # (see row_heights below).
#     [
#       ["This is a cell with quite a bit of text.", wrap_text: true],
#       # make some vertical alignment
#       ["Top", align_vertical: :top],
#       # also set font name
#       ["Middle", align_vertical: :center, font: "Courier New"],
#       ["Bottom", align_vertical: :bottom]
#     ],
#     # Unicode should work as well:
#     [["Müłti", bold: true, italic: true, underline: true, strike: true]],
#     # Change horizontal alignment
#     [
#       ["left", align_horizontal: :left],
#       ["right", align_horizontal: :right],
#       ["center", align_horizontal: :center],
#       ["justify", align_horizontal: :justify],
#       ["general", align_horizontal: :general],
#       ["fill", align_horizontal: :fill]
#     ]
#     ],
#     col_widths: %{"A" => 20.0, "B" => 10.0, "C" => 15.0},
#     row_heights: %{1 => 25, 2 => 20}
#   }
# ]
