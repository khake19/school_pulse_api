defmodule SchoolPulseApi.TeachersTest do
  use SchoolPulseApi.DataCase

  alias SchoolPulseApi.Teachers

  describe "teachers" do
    alias SchoolPulseApi.Teachers.Teacher

    import SchoolPulseApi.TeachersFixtures

    @invalid_attrs %{position: nil}

    test "list_teachers/0 returns all teachers" do
      teacher = teacher_fixture()
      assert Teachers.list_teachers() == [teacher]
    end

    test "get_teacher!/1 returns the teacher with given id" do
      teacher = teacher_fixture()
      assert Teachers.get_teacher!(teacher.id) == teacher
    end

    test "create_teacher/1 with valid data creates a teacher" do
      valid_attrs = %{position: "some position"}

      assert {:ok, %Teacher{} = teacher} = Teachers.create_teacher(valid_attrs)
      assert teacher.position == "some position"
    end

    test "create_teacher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teachers.create_teacher(@invalid_attrs)
    end

    test "update_teacher/2 with valid data updates the teacher" do
      teacher = teacher_fixture()
      update_attrs = %{position: "some updated position"}

      assert {:ok, %Teacher{} = teacher} = Teachers.update_teacher(teacher, update_attrs)
      assert teacher.position == "some updated position"
    end

    test "update_teacher/2 with invalid data returns error changeset" do
      teacher = teacher_fixture()
      assert {:error, %Ecto.Changeset{}} = Teachers.update_teacher(teacher, @invalid_attrs)
      assert teacher == Teachers.get_teacher!(teacher.id)
    end

    test "delete_teacher/1 deletes the teacher" do
      teacher = teacher_fixture()
      assert {:ok, %Teacher{}} = Teachers.delete_teacher(teacher)
      assert_raise Ecto.NoResultsError, fn -> Teachers.get_teacher!(teacher.id) end
    end

    test "change_teacher/1 returns a teacher changeset" do
      teacher = teacher_fixture()
      assert %Ecto.Changeset{} = Teachers.change_teacher(teacher)
    end
  end

  describe "positions" do
    alias SchoolPulseApi.Teachers.Position

    import SchoolPulseApi.TeachersFixtures

    @invalid_attrs %{name: nil, salary_grade: nil}

    test "list_positions/0 returns all positions" do
      position = position_fixture()
      assert Teachers.list_positions() == [position]
    end

    test "get_position!/1 returns the position with given id" do
      position = position_fixture()
      assert Teachers.get_position!(position.id) == position
    end

    test "create_position/1 with valid data creates a position" do
      valid_attrs = %{name: "some name", salary_grade: "some salary_grade"}

      assert {:ok, %Position{} = position} = Teachers.create_position(valid_attrs)
      assert position.name == "some name"
      assert position.salary_grade == "some salary_grade"
    end

    test "create_position/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teachers.create_position(@invalid_attrs)
    end

    test "update_position/2 with valid data updates the position" do
      position = position_fixture()
      update_attrs = %{name: "some updated name", salary_grade: "some updated salary_grade"}

      assert {:ok, %Position{} = position} = Teachers.update_position(position, update_attrs)
      assert position.name == "some updated name"
      assert position.salary_grade == "some updated salary_grade"
    end

    test "update_position/2 with invalid data returns error changeset" do
      position = position_fixture()
      assert {:error, %Ecto.Changeset{}} = Teachers.update_position(position, @invalid_attrs)
      assert position == Teachers.get_position!(position.id)
    end

    test "delete_position/1 deletes the position" do
      position = position_fixture()
      assert {:ok, %Position{}} = Teachers.delete_position(position)
      assert_raise Ecto.NoResultsError, fn -> Teachers.get_position!(position.id) end
    end

    test "change_position/1 returns a position changeset" do
      position = position_fixture()
      assert %Ecto.Changeset{} = Teachers.change_position(position)
    end
  end
end
