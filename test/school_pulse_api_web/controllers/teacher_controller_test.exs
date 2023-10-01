defmodule SchoolPulseApiWeb.TeacherControllerTest do
  use SchoolPulseApiWeb.ConnCase

  import SchoolPulseApi.TeachersFixtures

  alias SchoolPulseApi.Teachers.Teacher

  @create_attrs %{
    position: "some position"
  }
  @update_attrs %{
    position: "some updated position"
  }
  @invalid_attrs %{position: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all teachers", %{conn: conn} do
      conn = get(conn, ~p"/api/teachers")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create teacher" do
    test "renders teacher when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/teachers", teacher: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/teachers/#{id}")

      assert %{
               "id" => ^id,
               "position" => "some position"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/teachers", teacher: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update teacher" do
    setup [:create_teacher]

    test "renders teacher when data is valid", %{conn: conn, teacher: %Teacher{id: id} = teacher} do
      conn = put(conn, ~p"/api/teachers/#{teacher}", teacher: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/teachers/#{id}")

      assert %{
               "id" => ^id,
               "position" => "some updated position"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, teacher: teacher} do
      conn = put(conn, ~p"/api/teachers/#{teacher}", teacher: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete teacher" do
    setup [:create_teacher]

    test "deletes chosen teacher", %{conn: conn, teacher: teacher} do
      conn = delete(conn, ~p"/api/teachers/#{teacher}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/teachers/#{teacher}")
      end
    end
  end

  defp create_teacher(_) do
    teacher = teacher_fixture()
    %{teacher: teacher}
  end
end
