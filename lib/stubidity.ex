defmodule Stubidity do
  @moduledoc """
  A plug that stubs popular foundation model APIs for development and testing
  purposes.
  """
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/hello" do
    conn |> send_resp(200, "world")
  end

  post "/openai/v1/chat/completions" do
    Stubidity.OpenAI.ChatCompletion.chat_completion(conn)
  end

  match _ do
    conn |> send_resp(404, "not found")
  end
end
