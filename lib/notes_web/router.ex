defmodule NotesWeb.Router do
  use NotesWeb, :router
  import NotesWeb.Plugin.Auth

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", NotesWeb do
    pipe_through :api

    # Api versioning
    scope "/v1" do
      # Public scope for auth
      scope "/auth" do
        post "/sign-in", SessionController, :sign_in
        post "/sign-up", SessionController, :sign_up
      end

      # Private scope | requires authentication
      scope "/" do
        # Disable auth for test env
        if Mix.env() != :test do
          pipe_through :require_auth
        end

        resources "/users", UserController, except: [:new, :create, :edit, :index] do
          # Notes shared with user
          get "/shares", ShareController, :shares
          # Notes shared by user
          get "/shared", ShareController, :index
          post "/notes/:note_id/share", ShareController, :create

          resources "/notes", NoteController, except: [:new, :edit] do
            resources "/files", FileController, except: [:new, :edit]
          end
        end
      end
    end
  end

  # Live Dashboard
  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:fetch_session, :protect_from_forgery]
    live_dashboard "/dashboard", metrics: NotesWeb.Telemetry
  end
end
