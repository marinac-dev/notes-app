defmodule NotesWeb.FileControllerTest do
  use NotesWeb.ConnCase

  alias File, as: FS

  @create_attrs %{
    file_content: FS.read!("test/files/water.mp3") |> Base.url_encode64(),
    name: "the_murmur_of_water",
    extension: ".mp3",
    user_id: nil,
    note_id: nil
  }
  @update_attrs %{
    file_content: FS.read!("test/files/hello.txt") |> Base.url_encode64(),
    extension: ".txt",
    name: "hello",
    user_id: nil,
    note_id: nil
  }
  @invalid_attrs %{extension: nil, name: nil, file_content: nil}

  # Import file later to avoid `File` colision
  alias Notes.Accounts
  alias Notes.Accounts.File

  def fixture(:file) do
    {:ok, user} =
      Accounts.create_user(%{username: "admin", password: "ebjLD3d6$k2h^pAjetXqMKtgW2m$RwV4"})

    {:ok, note} = Accounts.create_note(%{content: "I need to feed my cat!", user_id: user.id})
    {:ok, file} = Accounts.create_file(%{@create_attrs | user_id: user.id, note_id: note.id})
    file
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all files", %{conn: conn} do
      conn = get(conn, Routes.user_note_file_path(conn, :index, 1, 1))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create file" do
    test "renders file when data is valid", %{conn: conn} do
      file = fixture(:file)
      conn = conn |> assign(:user_id, file.user_id)

      conn =
        post(conn, Routes.user_note_file_path(conn, :create, file.user_id, file.note_id),
          file: %{@update_attrs | user_id: file.user_id, note_id: file.note_id}
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_note_file_path(conn, :show, file.user_id, file.note_id, id))

      assert %{
               "id" => _id,
               "extension" => ".txt",
               "name" => "hello"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      file = fixture(:file)
      conn = conn |> assign(:user_id, file.user_id)

      conn =
        post(conn, Routes.user_note_file_path(conn, :create, file.user_id, file.note_id),
          file: @update_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update file" do
    test "renders file when data is valid", %{conn: conn} do
      %File{id: id} = file = fixture(:file)

      conn =
        put(conn, Routes.user_note_file_path(conn, :update, file.user_id, file.note_id, file),
          file: %{@update_attrs | user_id: file.user_id, note_id: file.note_id}
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_note_file_path(conn, :show, file.user_id, file.note_id, id))

      assert %{
               "id" => _id,
               "extension" => ".txt",
               "name" => "hello"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      file = fixture(:file)

      conn =
        put(conn, Routes.user_note_file_path(conn, :update, file.user_id, file.note_id, file),
          file: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete file" do
    test "deletes chosen file", %{conn: conn} do
      file = fixture(:file)

      conn =
        delete(conn, Routes.user_note_file_path(conn, :delete, file.user_id, file.note_id, file))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_note_file_path(conn, :show, file.user_id, file.note_id, file))
      end
    end
  end
end
