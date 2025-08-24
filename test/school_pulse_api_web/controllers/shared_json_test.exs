defmodule SchoolPulseApiWeb.SharedJSONTest do
  use SchoolPulseApiWeb.ConnCase

  alias SchoolPulseApiWeb.SharedJSON

  describe "meta_data/1" do
    test "converts Flop metadata to consistent format" do
      meta = %{
        current_page: 2,
        current_offset: 20,
        page_size: 10,
        total_count: 45,
        total_pages: 5
      }

      result = SharedJSON.meta_data(meta)

      assert result.current_page == 2
      assert result.current_offset == 20
      assert result.size == 10
      assert result.total == 45
      assert result.pages == 5
    end
  end

  describe "paginated_response/2" do
    test "creates standard paginated response structure using pipes" do
      data = [%{id: 1, name: "Test"}]

      meta = %{
        current_page: 1,
        current_offset: 0,
        page_size: 10,
        total_count: 1,
        total_pages: 1
      }

      result = SharedJSON.paginated_response(data, meta)

      assert result.data == data
      assert result.meta.current_page == 1
      assert result.meta.size == 10
      assert result.meta.total == 1
    end
  end

  describe "error_response/2" do
    test "creates standard error response structure using pipes" do
      result = SharedJSON.error_response("Something went wrong", "validation_error")

      assert result.error.message == "Something went wrong"
      assert result.error.code == "validation_error"
    end

    test "uses default code when not provided" do
      result = SharedJSON.error_response("Something went wrong")

      assert result.error.message == "Something went wrong"
      assert result.error.code == "error"
    end
  end

  describe "success_response/2" do
    test "creates standard success response structure using pipes" do
      data = %{id: 1, name: "Test"}
      result = SharedJSON.success_response(data, "Created successfully")

      assert result.data == data
      assert result.message == "Created successfully"
    end

    test "uses default message when not provided" do
      data = %{id: 1, name: "Test"}
      result = SharedJSON.success_response(data)

      assert result.data == data
      assert result.message == "Success"
    end
  end
end
