defmodule StubidityTest do
  use Plug.Test
  use ExUnit.Case
  doctest Stubidity

  test "greets the world" do
    conn =
      conn(:get, "/hello")
      |> Stubidity.call(Stubidity.init([]))

    assert conn.status == 200
  end

  test "it requires an authorization header bearer token" do
    conn =
      conn(:post, "/openai/v1/chat/completions")
      |> Stubidity.call(Stubidity.init([]))

    assert conn.status == 401
    assert conn.resp_body =~ "You didn't provide an API key"
  end

  test "it does not 401 when provided a bearer token" do
    conn =
      conn(:post, "/openai/v1/chat/completions")
      |> put_req_header("authorization", "Bearer foo")
      |> Stubidity.call(Stubidity.init([]))

    assert conn.status != 401
  end

  test "it validates `model` body parameter" do
    conn =
      conn(:post, "/openai/v1/chat/completions")
      |> put_req_header("authorization", "Bearer foo")
      |> Stubidity.call(Stubidity.init([]))

    assert conn.status == 400
    assert conn.resp_body =~ "you must provide"
  end

  test "it returns a valid chat completion" do
    conn =
      conn(:post, "/openai/v1/chat/completions", %{"model" => "gpt-3.5-0301"})
      |> put_req_header("authorization", "Bearer foo")
      |> Stubidity.call(Stubidity.init([]))

    assert conn.status == 200
    assert conn.resp_body =~ "Why don't scientists trust atoms?"
  end

  test "it supports streaming" do
    conn =
      conn(
        :post,
        "/openai/v1/chat/completions",
        %{
          "model" => "gpt-3.5-0301",
          "stream" => true
        }
      )
      |> put_req_header("authorization", "Bearer foo")
      |> Stubidity.call(Stubidity.init([]))

    assert conn.status == 200
  end
end
