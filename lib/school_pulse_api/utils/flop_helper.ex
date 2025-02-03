defmodule SchoolPulseApi.Utils.FlopHelper do
  def transform_search_params(%{"filterSearch" => search_term} = params, filter_fields)
      when is_list(filter_fields) do
    filters =
      Enum.map(filter_fields, fn field ->
        %{field: field, op: :ilike, value: search_term}
      end)

    params
    |> Map.drop(["filterSearch"])
    |> Map.put("filters", filters)
  end

  def transform_search_params(params, _filter_fields), do: params
end
