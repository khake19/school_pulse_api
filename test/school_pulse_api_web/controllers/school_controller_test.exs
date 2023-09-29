defmodule SchoolPulseApiWeb.SchoolControllerTest do
  use SchoolPulseApiWeb.ConnCase

  import SchoolPulseApi.SchoolsFixtures

  alias SchoolPulseApi.Schools.School

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all schools", %{conn: conn} do
      conn = get(conn, ~p"/api/schools")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create school" do
    test "renders school when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/schools", school: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/schools/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/schools", school: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update school" do
    setup [:create_school]

    test "renders school when data is valid", %{conn: conn, school: %School{id: id} = school} do
      conn = put(conn, ~p"/api/schools/#{school}", school: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/schools/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, school: school} do
      conn = put(conn, ~p"/api/schools/#{school}", school: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete school" do
    setup [:create_school]

    test "deletes chosen school", %{conn: conn, school: school} do
      conn = delete(conn, ~p"/api/schools/#{school}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/schools/#{school}")
      end
    end
  end

  defp create_school(_) do
    school = school_fixture()
    %{school: school}
  end
end
