defmodule SchoolPulseApi.AccountsTest do
  use SchoolPulseApi.DataCase

  alias SchoolPulseApi.Accounts

  describe "users" do
    alias SchoolPulseApi.Accounts.User

    import SchoolPulseApi.AccountsFixtures

    @invalid_attrs %{first_name: nil, last_name: nil, email: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        first_name: "some first_name",
        last_name: "some last_name",
        email: "some email"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        email: "some updated email"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "documents" do
    alias SchoolPulseApi.Accounts.Document

    import SchoolPulseApi.AccountsFixtures

    @invalid_attrs %{}

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Accounts.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Accounts.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      valid_attrs = %{}

      assert {:ok, %Document{} = document} = Accounts.create_document(valid_attrs)
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      update_attrs = %{}

      assert {:ok, %Document{} = document} = Accounts.update_document(document, update_attrs)
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_document(document, @invalid_attrs)
      assert document == Accounts.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Accounts.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Accounts.change_document(document)
    end
  end
end
