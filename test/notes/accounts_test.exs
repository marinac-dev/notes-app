defmodule Notes.AccountsTest do
  use Notes.DataCase

  alias Notes.Accounts

  describe "users" do
    alias Notes.Accounts.User

    @valid_attrs %{password: "yrwM4Nefq*M4gmWdXv2p7Mfyx4hLU$Ye", username: "super0user"}
    @update_attrs %{
      password: "XrwM4Nefq*M4gmWdXv2p7Mfyx4hLU$YA",
      username: "admin1337"
    }
    @invalid_attrs %{password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert User.valid_password?(user, "yrwM4Nefq*M4gmWdXv2p7Mfyx4hLU$Ye")
      assert user.username == "super0user"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert User.valid_password?(user, "XrwM4Nefq*M4gmWdXv2p7Mfyx4hLU$YA")
      assert user.username == "admin1337"
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

  describe "shares" do
    alias Notes.Accounts.Share

    @valid_attrs %{
      note_id: 1,
      owner_id: 1,
      share_id: 2
    }
    @update_attrs %{
      note_id: 2,
      owner_id: 1,
      share_id: 1
    }
    @invalid_attrs %{
      note_id: nil,
      owner_id: nil,
      share_id: nil
    }

    def user_note_fixture do
      user_params = %{username: "admin", password: "RaU#ok#fpo5CJRfNzj2r@F8R^KE*P^Y$"}
      {:ok, user} = Accounts.create_user(user_params)
      user_params = %{username: "admin2", password: "4CxvzrGt!C2Tkn%ej5vDnuG%mLq&yg6z"}
      {:ok, user2} = Accounts.create_user(user_params)
      text = "Non minim amet dolore laborum ex."
      {:ok, note} = Accounts.create_note(%{user_id: user.id, content: text})
      {user, user2, note}
    end

    def share_fixture(attrs \\ %{}) do
      {u1, u2, n} = user_note_fixture()

      {:ok, share} =
        attrs
        |> Enum.into(%{
          owner_id: u1.id,
          share_id: u2.id,
          note_id: n.id
        })
        |> Accounts.create_share()

      share
    end

    test "get_share!/1 returns the share with given id" do
      share = share_fixture()
      assert Accounts.get_share!(share.id) == share
    end

    test "create_share/1 with valid data creates a share" do
      {u1, u2, n} = user_note_fixture()

      assert {:ok, %Share{} = share} =
               Accounts.create_share(%{owner_id: u1.id, share_id: u2.id, note_id: n.id})
    end

    test "create_share/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_share(@invalid_attrs)
    end

    test "update_share/2 with valid data updates the share" do
      share = share_fixture()

      assert {:ok, %Share{} = share} =
               Accounts.update_share(share, %{
                 owner_id: share.share_id,
                 share_id: share.owner_id,
                 note_id: share.note_id
               })
    end

    test "update_share/2 with invalid data returns error changeset" do
      share = share_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_share(share, @invalid_attrs)
      assert share == Accounts.get_share!(share.id)
    end

    test "delete_share/1 deletes the share" do
      share = share_fixture()
      assert {:ok, %Share{}} = Accounts.delete_share(share)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_share!(share.id) end
    end

    test "change_share/1 returns a share changeset" do
      share = share_fixture()
      assert %Ecto.Changeset{} = Accounts.change_share(share)
    end
  end
end
