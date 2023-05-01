defmodule StubidityTest do
  use Plug.Test
  use ExUnit.Case
  doctest Stubidity

  describe "/v1/chat/completions" do

    test "it requires an authorization header bearer token" do
      conn =
        conn(:post, "/v1/chat/completions")
        |> Stubidity.call([])

      assert conn.status == 401
      assert conn.resp_body =~ "You didn't provide an API key"
    end

    test "it does not 401 when provided a bearer token" do
      conn =
        conn(:post, "/v1/chat/completions")
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status != 401
    end

    test "it validates `model` body parameter" do
      conn =
        conn(:post, "/v1/chat/completions")
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 400
      assert conn.resp_body =~ "you must provide"
    end

    test "it returns a valid chat completion" do
      conn =
        conn(:post, "/v1/chat/completions", %{"model" => "gpt-3.5-0301"})
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 200
      assert conn.resp_body =~ "Why don't scientists trust atoms?"
    end

    test "it supports streaming" do
      conn =
        conn(
          :post,
          "/v1/chat/completions",
          %{
            "model" => "gpt-3.5-0301",
            "stream" => true
          }
        )
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 200
    end

  end

  describe "/v1/completions" do

    test "it requires an authorization header bearer token" do
      conn =
        conn(:post, "/v1/completions")
        |> Stubidity.call([])

      assert conn.status == 401
      assert conn.resp_body =~ "You didn't provide an API key"
    end

    test "it does not 401 when provided a bearer token" do
      conn =
        conn(:post, "/v1/completions")
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status != 401
    end

    test "it validates `model` body parameter" do
      conn =
        conn(:post, "/v1/completions")
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 400
      assert conn.resp_body =~ "you must provide"
    end

    test "it returns a valid completion" do
      conn =
        conn(:post, "/v1/completions", %{"model" => "text-davinci-003"})
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 200
      assert conn.resp_body =~ "I am writing to request"
    end

    test "it supports streaming" do
      conn =
        conn(
          :post,
          "/v1/completions",
          %{
            "model" => "text-davinci-003",
            "stream" => true
          }
        )
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 200
    end

  end

  describe "/v1/embeddings" do

    test "it requires an authorization header bearer token" do
      conn =
        conn(:post, "/v1/embeddings")
        |> Stubidity.call([])

      assert conn.status == 401
      assert conn.resp_body =~ "You didn't provide an API key"
    end

    test "it does not 401 when provided a bearer token" do
      conn =
        conn(:post, "/v1/embeddings")
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status != 401
    end

    test "it validates `model` body parameter" do
      conn =
        conn(:post, "/v1/embeddings")
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 400
      assert conn.resp_body =~ "you must provide"
    end

    test "it returns a valid completion" do
      conn =
        conn(:post, "/v1/embeddings", %{"model" => "text-davinci-003"})
        |> put_req_header("authorization", "Bearer foo")
        |> Stubidity.call([])

      assert conn.status == 200
      assert String.length(conn.resp_body) > 10
    end

  end
end
