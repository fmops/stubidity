defmodule Stubidity.OpenAI.ChatCompletion do
  import Plug.Conn
  use OpenApiSpex.ControllerSpecs
  alias OpenApiSpex.Schema

  tags ["openai", "chat completions"]

  def init(_opts), do: nil

  operation :call,
    summary: "Chat completion",
    parameters: [
      %{
        in: "header",
        name: "authorization",
        required: true,
        schema: %{type: "string"}
      },
      %{
        in: "body",
        name: "model",
        required: true,
        schema: %{type: "string"}
      },
      %{
        in: "body",
        name: "stream",
        required: false,
        schema: %{type: "boolean"}
      }
    ],
  request_body: {
      "Chat completion params",
      "application/json",
      StubidityWeb.Schemas.ChatCompletion
  },
  responses: [
      ok: {
        "Chat completion response",
        "application/json",
        StubidityWeb.Schemas.ChatCompletionResponse
      },
    ]
  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
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
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"role\":\"assistant\"},\"index\":0,\"finish_reason\":null}]}\n\ndata: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\"Why\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" was\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" the\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" math\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" book\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" sad\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\"?\\n\\n\"},\"index\":0,\"finish_reason\":null}]}\n\ndata: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\"Because\"},\"index\":0,\"finish_reason\":null}]}\n\ndata: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" it\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" had\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" too\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" many\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" problems\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\".\"},\"index\":0,\"finish_reason\":null}]}\n\n",
      "data: {\"id\":\"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ\",\"object\":\"chat.completion.chunk\",\"created\":1680219904,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{},\"index\":0,\"finish_reason\":\"stop\"}]}\n\ndata: [DONE]\n\n"
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
