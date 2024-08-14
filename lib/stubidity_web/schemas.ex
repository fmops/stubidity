defmodule StubidityWeb.Schemas do
  alias OpenApiSpex.Schema

  defmodule ChatCompletion do
    require OpenApiSpex

    OpenApiSpex.schema( %{
      title: "Chat completion",
      description: "A request to chat with the model.",
      type: :object,
      properties: %{
        model: %Schema{type: "string"},
        stream: %Schema{type: "boolean"}
      },
      required: ["model"],
    })
  end

  defmodule ChatCompletionResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      type: :object
    })
  end
end

