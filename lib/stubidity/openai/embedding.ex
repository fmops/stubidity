defmodule Stubidity.OpenAI.Embedding do
  import Plug.Conn
  use OpenApiSpex.ControllerSpecs

  tags(["openai"])

  def init(_opts), do: nil

  operation(:call,
    summary: "Embedding",
    request_body: {
      "Embedding params",
      "application/json",
      StubidityWeb.Schemas.Embedding
    },
    responses: [
      ok: {
        "Embedding response",
        "application/json",
        StubidityWeb.Schemas.EmbeddingResponse
      }
    ]
  )

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      [] ->
        send_unauthorized(conn)

      _ ->
        # validate model
        case conn.body_params do
          %{"model" => _} ->
            send_embedding(conn)

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

  defp send_embedding(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      200,
      Jason.encode!(%{
        "data" => [
          %{
            "embedding" => for(_ <- 1..1536, do: 0.0),
            "index" => 0,
            "object" => "embedding"
          }
        ],
        "model" => "text-embedding-ada-002-v2",
        "object" => "list",
        "usage" => %{"prompt_tokens" => 4, "total_tokens" => 4}
      })
    )
  end
end
