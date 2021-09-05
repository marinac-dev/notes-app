defmodule Notes.Accounts.FileTest do
  use Notes.DataCase

  describe "files" do
    alias Notes.Accounts.File

    def file_fixture() do
      {:ok, bin} = Elixir.File.read("test/files/water.mp3")
      b64 = bin |> Base.url_encode64()
      name = "the_murmur_of_water"
      extension = ".mp3"
      {b64, name, extension}
    end

    test "upload/3 returns :ok and path to file with valid results" do
      {b64, name, ext} = file_fixture()
      assert {:ok, _} = File.upload(b64, name, ext)
    end
  end
end
