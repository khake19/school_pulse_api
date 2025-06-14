defmodule SchoolPulseApiWeb.LeaveControllerTest do
  use SchoolPulseApiWeb.ConnCase

  import SchoolPulseApi.LeavesFixtures

  alias SchoolPulseApi.Leaves.Leave

  @create_attrs %{
    type: "some type",
    remarks: "some remarks"
  }
  @update_attrs %{
    type: "some updated type",
    remarks: "some updated remarks"
  }
  @invalid_attrs %{type: nil, remarks: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all leaves", %{conn: conn} do
      conn = get(conn, ~p"/api/leaves")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create leave" do
    test "renders leave when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/leaves", leave: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/leaves/#{id}")

      assert %{
               "id" => ^id,
               "remarks" => "some remarks",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/leaves", leave: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update leave" do
    setup [:create_leave]

    test "renders leave when data is valid", %{conn: conn, leave: %Leave{id: id} = leave} do
      conn = put(conn, ~p"/api/leaves/#{leave}", leave: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/leaves/#{id}")

      assert %{
               "id" => ^id,
               "remarks" => "some updated remarks",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, leave: leave} do
      conn = put(conn, ~p"/api/leaves/#{leave}", leave: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete leave" do
    setup [:create_leave]

    test "deletes chosen leave", %{conn: conn, leave: leave} do
      conn = delete(conn, ~p"/api/leaves/#{leave}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/leaves/#{leave}")
      end
    end
  end

  defp create_leave(_) do
    leave = leave_fixture()
    %{leave: leave}
  end
end
