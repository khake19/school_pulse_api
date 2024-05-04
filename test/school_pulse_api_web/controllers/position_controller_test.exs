defmodule SchoolPulseApiWeb.PositionControllerTest do
  use SchoolPulseApiWeb.ConnCase

  import SchoolPulseApi.TeachersFixtures

  alias SchoolPulseApi.Teachers.Position

  @create_attrs %{
    name: "some name",
    salary_grade: "some salary_grade"
  }
  @update_attrs %{
    name: "some updated name",
    salary_grade: "some updated salary_grade"
  }
  @invalid_attrs %{name: nil, salary_grade: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all positions", %{conn: conn} do
      conn = get(conn, ~p"/api/positions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create position" do
    test "renders position when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/positions", position: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/positions/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "salary_grade" => "some salary_grade"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/positions", position: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update position" do
    setup [:create_position]

    test "renders position when data is valid", %{
      conn: conn,
      position: %Position{id: id} = position
    } do
      conn = put(conn, ~p"/api/positions/#{position}", position: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/positions/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "salary_grade" => "some updated salary_grade"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, position: position} do
      conn = put(conn, ~p"/api/positions/#{position}", position: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete position" do
    setup [:create_position]

    test "deletes chosen position", %{conn: conn, position: position} do
      conn = delete(conn, ~p"/api/positions/#{position}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/positions/#{position}")
      end
    end
  end

  defp create_position(_) do
    position = position_fixture()
    %{position: position}
  end
end
