# Shared JSON Utilities

This directory contains shared JSON utilities that can be reused across all controllers to ensure consistent API responses.

## SharedJSON Module

The `SharedJSON` module provides standardized functions for creating consistent API responses across all endpoints. All functions use Elixir's pipe operator (`|>`) for clean, readable code.

### Usage

```elixir
alias SchoolPulseApiWeb.SharedJSON

# In your JSON view module
def index(%{items: %{entries: entries, meta: meta}}) do
  SharedJSON.paginated_response(
    for(item <- entries, do: data(item)),
    meta
  )
end
```

### Available Functions

#### `meta_data/1`
Converts Flop metadata to a consistent format for API responses.

```elixir
meta = %{
  current_page: 2,
  current_offset: 20,
  page_size: 10,
  total_count: 45,
  total_pages: 5
}

result = SharedJSON.meta_data(meta)
# Returns:
# %{
#   current_page: 2,
#   current_offset: 20,
#   size: 10,
#   total: 45,
#   pages: 5
# }
```

#### `paginated_response/2`
Creates a standard paginated response structure using pipes for clean, readable code.

```elixir
data = [%{id: 1, name: "Item 1"}]
meta = %{current_page: 1, page_size: 10, total_count: 1, total_pages: 1}

result = SharedJSON.paginated_response(data, meta)
# Returns:
# %{
#   data: [%{id: 1, name: "Item 1"}],
#   meta: %{current_page: 1, size: 10, total: 1, pages: 1}
# }
```

#### `error_response/2`
Creates a standard error response structure using pipes.

```elixir
SharedJSON.error_response("Something went wrong", "validation_error")
# Returns:
# %{
#   error: %{
#     message: "Something went wrong",
#     code: "validation_error"
#   }
# }
```

#### `success_response/2`
Creates a standard success response structure using pipes.

```elixir
SharedJSON.success_response(%{id: 1, name: "Created"}, "Item created successfully")
# Returns:
# %{
#   data: %{id: 1, name: "Created"},
#   message: "Item created successfully"
# }
```

## Benefits

✅ **Consistency**: All endpoints return the same response structure  
✅ **Maintainability**: Changes to response format only need to be made in one place  
✅ **Reusability**: Easy to use across all controllers  
✅ **Standardization**: Follows API best practices  
✅ **Testing**: Centralized testing of response formats  
✅ **Readability**: Uses Elixir pipes for clean, idiomatic code  
✅ **Performance**: Efficient map operations with pipes

## Pipe-Based Implementation

All functions in the `SharedJSON` module use Elixir's pipe operator (`|>`) for clean, readable code:

### `paginated_response/2`
```elixir
def paginated_response(data, meta) do
  %{data: data}
  |> Map.put(:meta, meta_data(meta))
end
```

### `error_response/2`
```elixir
def error_response(message, code \\ "error") do
  %{error: %{message: message}}
  |> Map.put_in([:error, :code], code)
end
```

### `success_response/2`
```elixir
def success_response(data, message \\ "Success") do
  %{data: data}
  |> Map.put(:message, message)
end
```

This approach:
- **Improves readability** by showing the data transformation flow
- **Follows Elixir conventions** and best practices
- **Makes debugging easier** as you can see each step
- **Enables easy composition** of multiple transformations

## Migration Guide

If you have existing JSON views with local `meta_data` functions:

1. **Add the alias**:
   ```elixir
   alias SchoolPulseApiWeb.SharedJSON
   ```

2. **Replace local meta_data calls**:
   ```elixir
   # Before
   %{data: items, meta: meta_data(meta)}
   
   # After
   SharedJSON.paginated_response(items, meta)
   ```

3. **Remove local meta_data functions**:
   ```elixir
   # Remove this
   defp meta_data(meta) do
     %{
       current_page: meta.current_page,
       # ... other fields
     }
   end
   ```

## Example Implementation

Here's a complete example of how to use the SharedJSON module:

```elixir
defmodule SchoolPulseApiWeb.ExampleJSON do
  alias SchoolPulseApiWeb.SharedJSON

  def index(%{items: %{entries: entries, meta: meta}}) do
    SharedJSON.paginated_response(
      for(item <- entries, do: data(item)),
      meta
    )
  end

  def index(%{items: items}) when is_list(items) do
    %{data: for(item <- items, do: data(item))}
  end

  def show(%{item: item}) do
    SharedJSON.success_response(data(item))
  end

  defp data(%Item{} = item) do
    %{
      id: item.id,
      name: item.name
    }
  end
end
```

This approach ensures that all your API endpoints have consistent, professional responses that are easy to maintain and extend.
