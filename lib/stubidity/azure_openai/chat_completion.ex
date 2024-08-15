defmodule Stubidity.AzureOpenAI.ChatCompletion do
  import Plug.Conn

  def init(_opts), do: nil

  def call(conn), do: call(conn, [])

  def call(conn, _opts) do
    case get_req_header(conn, "api-key") do
      [] ->
        send_unauthorized(conn)

      _ ->
        # validate model
        case conn.body_params do
          %{"model" => _, "stream" => true} ->
            send_stream_completion(conn)

          %{"model" => _} ->
            send_sync_completion(conn)

          _ ->
            send_model_missing(conn)
        end
    end
  end

  defp send_unauthorized(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      401,
      Jason.encode!(%{
        "error" => %{
          "message" =>
            "You didn't provide an API key. You need to provide your API key in an Authorization header using Bearer auth (i.e. Authorization: Bearer YOUR_KEY), or as the password field (with blank username) if you're accessing the API from your browser and are prompted for a username and password. You can obtain an API key from https://platform.openai.com/account/api-keys.",
          "type" => "invalid_request_error",
          "param" => nil,
          "code" => nil
        }
      })
    )
  end

  defp send_model_missing(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      400,
      Jason.encode!(%{
        "error" => %{
          "message" => "you must provide a model parameter",
          "type" => "invalid_request_error",
          "param" => nil,
          "code" => nil
        }
      })
    )
  end

  defp send_sync_completion(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "choices" => [
          %{
            "message" => %{
              "content" => "Why don't scientists trust atoms? Because they make up everything.",
              "role" => "assistant"
            },
            "finish_reason" => nil,
            "index" => 0
          }
        ],
        "created" => 1_682_447_196,
        "id" => "chatcmpl-abc123",
        "model" => "gpt-3.5-turbo-0301",
        "object" => "chat.completion",
        "usage" => %{
          "completion_tokens" => 13,
          "prompt_tokens" => 3,
          "total_tokens" => 16
        }
      })
    )
  end

  defp send_stream_completion(conn) do
    conn =
      conn
      |> put_resp_header("content-type", "text/event-stream")
      |> send_chunked(200)

    [
      ~s(data: {"id":"","object":"","created":0,"model":"","prompt_filter_results":[{"prompt_index":0,"content_filter_results":{"hate":{"filtered":false,"severity":"safe"},"self_harm":{"filtered":false,"severity":"safe"},"sexual":{"filtered":false,"severity":"safe"},"violence":{"filtered":false,"severity":"safe"}}}],"choices":[]}\n\n),
      ~s(data: {"id":"chatcmpl-8jrp2gFYv9O6vpX2j9kU9wJBjmJlY","object":"chat.completion.chunk","created":1705942344,"model":"gpt-35-turbo","choices":[{"finish_reason":null,"index":0,"delta":{"role":"assistant"},"content_filter_results":{}}]}\n\n),
      ~s(data: {"id":"chatcmpl-8jrp2gFYv9O6vpX2j9kU9wJBjmJlY","object":"chat.completion.chunk","created":1705942344,"model":"gpt-35-turbo","choices":[{"finish_reason":null,"index":0,"delta":{"content":"This"},"content_filter_results":{"hate":{"filtered":false,"severity":"safe"},"self_harm":{"filtered":false,"severity":"safe"},"sexual":{"filtered":false,"severity":"safe"},"violence":{"filtered":false,"severity":"safe"}}}]}\n\n),
      ~s(data: {"id":"chatcmpl-8jrp2gFYv9O6vpX2j9kU9wJBjmJlY","object":"chat.completion.chunk","created":1705942344,"model":"gpt-35-turbo","choices":[{"finish_reason":null,"index":0,"delta":{"content":" is"},"content_filter_results":{"hate":{"filtered":false,"severity":"safe"},"self_harm":{"filtered":false,"severity":"safe"},"sexual":{"filtered":false,"severity":"safe"},"violence":{"filtered":false,"severity":"safe"}}}]}\n\n),
      ~s(data: {"id":"chatcmpl-8jrp2gFYv9O6vpX2j9kU9wJBjmJlY","object":"chat.completion.chunk","created":1705942344,"model":"gpt-35-turbo","choices":[{"finish_reason":null,"index":0,"delta":{"content":" a"},"content_filter_results":{"hate":{"filtered":false,"severity":"safe"},"self_harm":{"filtered":false,"severity":"safe"},"sexual":{"filtered":false,"severity":"safe"},"violence":{"filtered":false,"severity":"safe"}}}]}\n\n),
      ~s(data: {"id":"chatcmpl-8jrp2gFYv9O6vpX2j9kU9wJBjmJlY","object":"chat.completion.chunk","created":1705942344,"model":"gpt-35-turbo","choices":[{"finish_reason":null,"index":0,"delta":{"content":" test"},"content_filter_results":{"hate":{"filtered":false,"severity":"safe"},"self_harm":{"filtered":false,"severity":"safe"},"sexual":{"filtered":false,"severity":"safe"},"violence":{"filtered":false,"severity":"safe"}}}]}\n\n),
      ~s(data: {"id":"chatcmpl-8jrp2gFYv9O6vpX2j9kU9wJBjmJlY","object":"chat.completion.chunk","created":1705942344,"model":"gpt-35-turbo","choices":[{"finish_reason":null,"index":0,"delta":{"content":"."},"content_filter_results":{"hate":{"filtered":false,"severity":"safe"},"self_harm":{"filtered":false,"severity":"safe"},"sexual":{"filtered":false,"severity":"safe"},"violence":{"filtered":false,"severity":"safe"}}}]}\n\n),
      ~s(data: {"id":"chatcmpl-8jrp2gFYv9O6vpX2j9kU9wJBjmJlY","object":"chat.completion.chunk","created":1705942344,"model":"gpt-35-turbo","choices":[{"finish_reason":"stop","index":0,"delta":{},"content_filter_results":{}}]}\n\ndata: [DONE]\n\n)
    ]
    |> Enum.reduce_while(conn, fn chunk, conn ->
      :timer.sleep(100)

      case Plug.Conn.chunk(conn, chunk) do
        {:ok, conn} ->
          {:cont, conn}

        {:error, _reason, conn} ->
          {:halt, conn}
      end
    end)
  end
end
