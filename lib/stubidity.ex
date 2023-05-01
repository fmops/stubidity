defmodule Stubidity do
  @moduledoc """
  A plug that stubs popular foundation model APIs for development and testing
  purposes.
  """
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/v1/chat/completions" do
    Stubidity.OpenAI.ChatCompletion.call(conn)
  end

  post "/v1/completions" do
    Stubidity.OpenAI.Completion.call(conn)
  end

  post "/v1/embeddings" do
    Stubidity.OpenAI.Embedding.call(conn)
  end

  post "/v1/engines/:model" do
    Stubidity.OpenAI.Embedding.call(conn)
  end

  match _ do
    conn |> send_resp(404, "not found")
  end
end
