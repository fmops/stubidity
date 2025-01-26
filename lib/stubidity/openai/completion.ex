defmodule Stubidity.OpenAI.Completion do
  require Logger
  import Plug.Conn
  use OpenApiSpex.ControllerSpecs

  tags(["stub_openai"])

  def init(_opts), do: nil

  operation(:call,
    summary: "Completion",
    request_body: {
      "Completion params",
      "application/json",
      StubidityWeb.Schemas.Completion
    },
    responses: [
      ok: {
        "Completion response",
        "application/json",
        StubidityWeb.Schemas.CompletionResponse
      }
    ]
  )

  def call(conn) do
    call(conn, [])
  end

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
            "finish_reason" => "stop",
            "index" => 0,
            "logprobs" => nil,
            "text" =>
              ",\n\nI am writing to request a meeting with you to discuss a project I am working on. The project is an initiative to improve the educational system in our city.\n\nI have been researching the current state of education in our city and have identified several key areas for improvement. I believe that with the right collaboration between the local government and the community, we can make a difference in the lives of our students. I am confident that by working together, we can implement strategies that will have a positive impact on our students' success.\n\nI would like to meet with you to discuss the project further, including ways to get the community involved and how to ensure the success of the project.\n\nI look forward to hearing from you.\n\nSincerely,\n\n[Your Name]"
          }
        ],
        "created" => 1_680_215_054,
        "id" => "cmpl-6zuykU8ldkwZtmG7VSpt1nDUWW3jM",
        "model" => "text-davinci-003",
        "object" => "text_completion",
        "usage" => %{
          "completion_tokens" => 162,
          "prompt_tokens" => 1,
          "total_tokens" => 163
        }
      })
    )
  end

  defp send_stream_completion(conn) do
    conn = conn |> send_chunked(200)

    [
      "data: {\"id\": \"cmpl-6zv6ZipA8uBiSxlsM2iQiPS7909pg\", \"object\": \"text_completion\", \"created\": 1680215539, \"choices\": [{\"text\": \"ummy\", \"index\": 0, \"logprobs\": null, \"finish_reason\": null}], \"model\": \"text-davinci-003\"}\n\n",
      "data: {\"id\": \"cmpl-6zv6ZipA8uBiSxlsM2iQiPS7909pg\", \"object\": \"text_completion\", \"created\": 1680215539, \"choices\": [{\"text\": \" bear\", \"index\": 0, \"logprobs\": null, \"finish_reason\": null}], \"model\": \"text-davinci-003\"}\n\n",
      "data: {\"id\": \"cmpl-6zv6ZipA8uBiSxlsM2iQiPS7909pg\", \"object\": \"text_completion\", \"created\": 1680215539, \"choices\": [{\"text\": \"!\", \"index\": 0, \"logprobs\": null, \"finish_reason\": null}], \"model\": \"text-davinci-003\"}\n\n",
      "data: [DONE]\n\n"
    ]
    |> Enum.reduce_while(conn, fn chunk, conn ->
      :timer.sleep(100)

      case Plug.Conn.chunk(conn, chunk) do
        {:ok, conn} ->
          {:cont, conn}

        {:error, reason} ->
          Logger.error("Error chunking response: #{inspect(reason)}")
          {:halt, conn}
      end
    end)
  end
end
