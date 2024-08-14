defmodule StubidityWeb.Schemas do
  alias OpenApiSpex.Schema

  defmodule ChatCompletion do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Chat completion",
      description: "A request to chat with the model.",
      type: :object,
      properties: %{
        model: %Schema{type: "string"},
        stream: %Schema{type: "boolean"}
      },
      required: ["model"]
    })
  end

  defmodule ChatCompletionResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      type: :object
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
        stream: %Schema{type: "boolean"}
      },
      required: ["model"]
    })
  end

  defmodule CompletionResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      type: :object
    })
  end

  defmodule Embedding do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Embedding ",
      description: "A request to embed with the model.",
      type: :object,
      properties: %{
        model: %Schema{type: "string"},
        stream: %Schema{type: "boolean"}
      },
      required: ["model"]
    })
  end

  defmodule EmbeddingResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      type: :object
    })
  end
end
