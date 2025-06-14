defmodule SchoolPulseApi.LeavesTest do
  use SchoolPulseApi.DataCase

  alias SchoolPulseApi.Leaves

  describe "leaves" do
    alias SchoolPulseApi.Leaves.Leave

    import SchoolPulseApi.LeavesFixtures

    @invalid_attrs %{type: nil, remarks: nil}

    test "list_leaves/0 returns all leaves" do
      leave = leave_fixture()
      assert Leaves.list_leaves() == [leave]
    end

    test "get_leave!/1 returns the leave with given id" do
      leave = leave_fixture()
      assert Leaves.get_leave!(leave.id) == leave
    end

    test "create_leave/1 with valid data creates a leave" do
      valid_attrs = %{type: "some type", remarks: "some remarks"}

      assert {:ok, %Leave{} = leave} = Leaves.create_leave(valid_attrs)
      assert leave.type == "some type"
      assert leave.remarks == "some remarks"
    end

    test "create_leave/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leaves.create_leave(@invalid_attrs)
    end

    test "update_leave/2 with valid data updates the leave" do
      leave = leave_fixture()
      update_attrs = %{type: "some updated type", remarks: "some updated remarks"}

      assert {:ok, %Leave{} = leave} = Leaves.update_leave(leave, update_attrs)
      assert leave.type == "some updated type"
      assert leave.remarks == "some updated remarks"
    end

    test "update_leave/2 with invalid data returns error changeset" do
      leave = leave_fixture()
      assert {:error, %Ecto.Changeset{}} = Leaves.update_leave(leave, @invalid_attrs)
      assert leave == Leaves.get_leave!(leave.id)
    end

    test "delete_leave/1 deletes the leave" do
      leave = leave_fixture()
      assert {:ok, %Leave{}} = Leaves.delete_leave(leave)
      assert_raise Ecto.NoResultsError, fn -> Leaves.get_leave!(leave.id) end
    end

    test "change_leave/1 returns a leave changeset" do
      leave = leave_fixture()
      assert %Ecto.Changeset{} = Leaves.change_leave(leave)
    end
  end
end
