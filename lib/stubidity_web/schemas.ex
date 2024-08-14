defmodule StubidityWeb.Schemas do
  alias OpenApiSpex.Schema

  defmodule ChatCompletion do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Create chat completion",
      description: "Creates a model response for the given chat conversation.",
      type: :object,
      properties: %{
        messages: %Schema{type: :array, items: StubidityWeb.Schemas.ChatCompletionMessage},
        model: %Schema{type: "string"},
        stream: %Schema{type: "boolean"}
      },
      required: ["messages", "model"]
    })
  end

  defmodule ChatCompletionMessage do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Chat completion message",
      description: "A chat message in a conversation.",
      type: :object,
      properties: %{
        content: %Schema{type: "string"},
        role: %Schema{type: "string"}
      },
      required: ["content", "role"]
    })
  end

  defmodule ChatCompletionResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Chat completion response",
      type: :object,
      properties: %{
        choices: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              message: StubidityWeb.Schemas.ChatCompletionMessage
            }
          }
        },
        model: %Schema{type: "string"},
        id: %Schema{type: "string"}
      }
    })
  end

  defmodule Completion do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Completion",
      description: "A request to complete with the model.",
      type: :object,
      properties: %{
        model: %Schema{type: "string"},
        prompt: %Schema{type: "string"},
        stream: %Schema{type: "boolean"}
      },
      required: ["model", "prompt"]
    })
  end

  defmodule CompletionResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Completion response",
      description: "A completion response from the model.",
      type: :object,
      properties: %{
        id: %Schema{type: "string"},
        choices: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              text: %Schema{type: "string"}
            },
            required: ["message", "role"]
          }
        },
        model: %Schema{type: "string"}
      }
    })
  end

  defmodule Embedding do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Embedding ",
      description: "A request to embed with the model.",
      type: :object,
      properties: %{
        input: %Schema{type: "string"},
        model: %Schema{type: "string"}
      },
      required: ["input", "model"]
    })
  end

  defmodule EmbeddingResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Embedding response",
      description: "An embedding response from the model.",
      type: :array,
      items: %Schema{
        type: :object,
        properties: %{
          embedding: %Schema{type: :array, items: %Schema{type: :number}}
        }
      }
    })
  end
end
