defmodule Notes.Accounts.File do
  use Ecto.Schema
  import Ecto.Changeset

  @supported_files ~w(.txt .png .jpg .jpeg .gif .mkv .mp3 .mp4 .rar .7z .xz .tar .tar.gz .pdf .docx)
  @name_error "Only letters, numbers and underscores are allowed."
  # File upload limit to 20 MB
  @file_limit 1024 * 1024 * 20
  @file_size_error "File to big! Files bigger than 20MB are not allowed"

  schema "files" do
    field :name, :string
    field :path, :string
    field :extension, :string
    field :file_content, :string, virtual: true

    belongs_to :user, Notes.Accounts.User
    belongs_to :note, Notes.Accounts.Note

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:name, :extension, :file_content, :user_id, :note_id])
    |> validate_required([:name, :extension, :file_content, :user_id, :note_id])
    |> validate_inclusion(:extension, @supported_files)
    |> validate_length(:name, min: 2, max: 100)
    |> validate_format(:name, ~r/^[a-zA-Z0-9\_]+$/, message: @name_error)
    |> validate_size()
    |> upload_file()
  end

  @doc """
  Ensures that /priv/static/uploads exists\n
  The path is used for local file uploads
  """
  def ensure_path() do
    with true <- File.exists?("priv"),
         true <- File.exists?("priv/static"),
         true <- File.exists?("priv/static/uploads") do
      :ok
    else
      false ->
        File.mkdir("priv")
        File.mkdir("priv/static")
        File.mkdir("priv/static/uploads")
        ensure_path()
    end
  end

  @doc """
  Accepts a URL safe base64 encoded file and uploads it locally.\n
  Returns {:ok, path} or {:error, reason}
  """
  @spec upload(String.t(), String.t(), String.t()) :: String.t()
  def upload(file_base64, file_name, file_extension) do
    # Decode the file
    {:ok, file_binary} = Base.url_decode64(file_base64)

    # Generate a unique filename
    filename = unique_filename({file_name, file_extension})

    upload_path = Application.app_dir(:notes, "priv/static/uploads/")
    dest = Path.join([upload_path, filename])

    case File.write(dest, file_binary) do
      :ok -> {:ok, dest}
      err -> err
    end
  end

  # Generates UUID type 4
  @spec unique_filename({String.t(), String.t()}) :: String.t()
  def unique_filename({filename, extension}) when extension in @supported_files,
    do: UUID.uuid4(:hex) <> "_#{filename}" <> extension

  # * Private

  defp upload_file(%Ecto.Changeset{errors: []} = changeset) do
    name = get_change(changeset, :name)
    extension = get_change(changeset, :extension)
    content = get_change(changeset, :file_content)

    case upload(content, name, extension) do
      {:ok, path} ->
        changeset
        |> put_change(:path, path)
        |> delete_change(:file_content)

      _err ->
        changeset
        |> add_error(:unknow, "Unknown error occured")
    end
  end

  defp upload_file(cs), do: cs

  defp validate_size(%Ecto.Changeset{errors: []} = changeset) do
    content_size = get_change(changeset, :file_content) |> byte_size()

    if content_size <= @file_limit,
      do: changeset,
      else: add_error(changeset, :file_content, @file_size_error)
  end

  defp validate_size(cs), do: cs
end
