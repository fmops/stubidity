# Stubidity

[![Build Status](https://github.com/fmops/stubidity/workflows/Elixir%20CI/badge.svg)](https://github.com/fmops/stubidity/actions/workflows/elixir.yml) [![Hex.pm](https://img.shields.io/hexpm/v/stubidity.svg)](https://hex.pm/packages/stubidity) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/stubidity)

> Stupidity is doing the same thing over and over and expecting different results.

Save money 💸; stop burning 🔥 tokens during dev/test.

Save time ⏰; avoid [Heisenbugs](https://en.wikipedia.org/wiki/Heisenbug) 🥸 and flaky tests 🤞 deterministic API stub 🎯.

## Getting started

The package can be installed by adding `stubidity` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:stubidity, "~> 0.2.0"}
  ]
end
```

It can then be mounted in another `Plug.Router`, for example:

```elixir
defmodule ExampleWeb.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  forward("/stub", Stubidity)
end
```

## Client usage

To use in your project, set your OpenAI base url to the path where Stubidity is running.
You are welcome to use a public instance of Stubidity at [`https://fmops.ai/api/v1/stub/openai/v1`](https://fmops.ai/api/v1/stub/openai/v1). For example:

```python
import openai

openai.api_base = "https://fmops.ai/api/v1/stub/openai/v1"
```

Stubidity aims to provide a faithful API stub, so request headers and bodies must conform to the expected schemas. One notable exception is the API key, where any non-empty value is considered valid.

To create a ChatGPT completion with `curl`:

```sh
curl \
  -H "content-type: application/json" \
  -H "authorization: bearer foo" \
  -X POST \
  https://fmops.ai/api/v1/stub/openai/v1/chat/completions \
  -d '{"model": "gpt-3.5-turbo","messages": [{"role": "system", "message": "tell me a joke"}]}'
```

```
{"choices":[{"finish_reason":null,"index":0,"message":{"content":"Why don't scientists trust atoms? Because they make up everything.","role":"assistant"}}],"created":1682447196,"id":"chatcmpl-abc123","model":"gpt-3.5-turbo-0301","object":"chat.completion","usage":{"completion_tokens":13,"prompt_tokens":3,"total_tokens":16}}
```

Streaming is also supported:

```sh
curl \
  -H "content-type: application/json" \
  -H "authorization: bearer foo" \
  -X POST \
  https://fmops.ai/api/v1/stub/openai/v1/chat/completions \
  -d '{"model": "gpt-3.5-turbo","messages": [{"role": "system", "message": "tell me a joke"}]}'
```

```
data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"role":"assistant"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":"Why"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" was"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" the"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" math"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" book"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" sad"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":"?\n\n"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":"Because"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" it"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" had"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" too"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" many"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":" problems"},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{"content":"."},"index":0,"finish_reason":null}]}

data: {"id":"chatcmpl-6zwEy96ojYcDRcdNX8f4L9fu95CaJ","object":"chat.completion.chunk","created":1680219904,"model":"gpt-3.5-turbo-0301","choices":[{"delta":{},"index":0,"finish_reason":"stop"}]}

data: [DONE]
```

## Features and roadmap

  - OpenAI
    - `/chat/completions` buffered and streaming
    
### Roadmap 
  - OpenAI
    - `/completions` buffered and streaming
  - HuggingFace
    - gpt2 buffered
    - bloomz buffered and streaming


## Copyright and License

Copyright (c) 2023, Feynman Liang.

Stubidity source code is licensed under the [Apache 2.0 License](LICENSE).
