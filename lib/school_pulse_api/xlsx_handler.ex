defmodule SchoolPulseApi.XlsxHandler do
  alias XlsxReader
  alias Elixlsx.{Workbook, Sheet}

  def read_and_transform_xlsx(file_path) do
    require IEx; IEx.pry()
    case XlsxReader.open(file_path) do
      {:ok, package} ->
        require IEx; IEx.pry()
        transformed_data = transform_data(package)

      {:error, reason} ->
        {:error, "Failed to read XLSX file: #{reason}"}
    end
  end

  defp transform_data(workbook) do
    require IEx; IEx.pry()
  end


end
