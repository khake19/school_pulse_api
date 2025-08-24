defmodule SchoolPulseApi.SchoolsTest do
  use SchoolPulseApi.DataCase

  alias SchoolPulseApi.Schools

  describe "schools" do
    alias SchoolPulseApi.Schools.School

    import SchoolPulseApi.SchoolsFixtures

    @invalid_attrs %{name: nil}

    test "list_schools/2 returns schools with pagination and permission checking" do
      # Create a test user with admin role (role_id: 1)
      user = %SchoolPulseApi.Accounts.User{id: "test-user-id", role_id: 1}

      school1 = school_fixture(%{name: "School 1"})
      school2 = school_fixture(%{name: "School 2"})

      # Test without pagination params (should return all)
      result = Schools.list_schools(user)
      assert {:ok, %{entries: entries, meta: meta}} = result
      assert length(entries) == 2
      assert meta

      # Test with pagination params
      result = Schools.list_schools(user, %{"page" => 1, "page_size" => 1})
      assert {:ok, %{entries: entries, meta: meta}} = result
      assert length(entries) == 1
      assert meta
      assert meta.current_page == 1
      assert meta.page_size == 1
    end

    test "list_schools/2 denies access to unauthorized users" do
      # Create a test user without admin role (role_id: 2 - school admin)
      user = %SchoolPulseApi.Accounts.User{id: "test-user-id", role_id: 2}

      result = Schools.list_schools(user)
      assert {:error, :forbidden} = result
    end

    test "list_school_summaries/2 returns schools with teacher counts and pagination" do
      # Create a test user with admin role (role_id: 1)
      user = %SchoolPulseApi.Accounts.User{id: "test-user-id", role_id: 1}

      school1 = school_fixture(%{name: "School 1"})
      school2 = school_fixture(%{name: "School 2"})

      # Test without pagination params (should return all)
      result = Schools.list_school_summaries(user)
      assert {:ok, %{entries: entries, meta: meta}} = result
      assert length(entries) == 2
      assert meta

      # Test with pagination params
      result = Schools.list_school_summaries(user, %{"page" => 1, "page_size" => 1})
      assert {:ok, %{entries: entries, meta: meta}} = result
      assert length(entries) == 1
      assert meta
      assert meta.current_page == 1
      assert meta.page_size == 1
    end

    test "list_school_summaries/2 denies access to unauthorized users" do
      # Create a test user without admin role (role_id: 2 - school admin)
      user = %SchoolPulseApi.Accounts.User{id: "test-user-id", role_id: 2}

      result = Schools.list_school_summaries(user)
      assert {:error, :forbidden} = result
    end

    test "get_school!/1 returns the school with given id" do
      school = school_fixture()
      assert Schools.get_school!(school.id) == school
    end

    test "create_school/1 with valid data creates a school" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %School{} = school} = Schools.create_school(valid_attrs)
      assert school.name == "some name"
    end

    test "create_school/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schools.create_school(@invalid_attrs)
    end

    test "update_school/2 with valid data updates the school" do
      school = school_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %School{} = school} = Schools.update_school(school, update_attrs)
      assert school.name == "some updated name"
    end

    test "update_school/2 with invalid data returns error changeset" do
      school = school_fixture()
      assert {:error, %Ecto.Changeset{}} = Schools.update_school(school, @invalid_attrs)
      assert school == Schools.get_school!(school.id)
    end

    test "delete_school/1 deletes the school" do
      school = school_fixture()
      assert {:ok, %School{}} = Schools.delete_school(school)
      assert_raise Ecto.NoResultsError, fn -> Schools.get_school!(school.id) end
    end

    test "change_school/1 returns a school changeset" do
      school = school_fixture()
      assert %Ecto.Changeset{} = Schools.change_school(school)
    end
  end
end
