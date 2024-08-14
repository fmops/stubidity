defmodule StubidityWeb.Router do
  use StubidityWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug(Plug.Parsers,
      parsers: [:json],
      pass: ["application/json"],
      json_decoder: Jason
    )
  end

  scope "/api", Stubidity do
    pipe_through :api

    post "/v1/chat/completions", OpenAI.ChatCompletion, []

    post "/v1/completions", OpenAI.Completion, []

    post "/v1/embeddings", OpenAI.Embedding, []

    post "/v1/engines/:model", OpenAI.Embedding, []
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:stubidity, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: StubidityWeb.Telemetry
    end
  end
end
