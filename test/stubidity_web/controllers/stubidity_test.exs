defmodule StubidityWeb.StubidityTest do
  use StubidityWeb.ConnCase

  doctest Stubidity

  describe "/v1/chat/completions" do
    test "it requires an authorization header bearer token", %{conn: conn} do
      conn =
        conn
        |> post(~p"/api/v1/chat/completions")

      assert conn.status == 401
      assert conn.resp_body =~ "You didn't provide an API key"
    end

    test "it does not 401 when provided a bearer token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/chat/completions")

      assert conn.status != 401
    end

    test "it validates `model` body parameter", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/chat/completions")

      assert conn.status == 400
      assert conn.resp_body =~ "you must provide"
    end

    test "it returns a valid chat completion", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/chat/completions", %{"model" => "gpt-3.5-0301"})

      assert conn.status == 200
      assert conn.resp_body =~ "Why don't scientists trust atoms?"
    end

    test "it supports streaming", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(
          ~p"/api/v1/chat/completions",
          %{
            "model" => "gpt-3.5-0301",
            "stream" => true
          }
        )

      assert conn.status == 200
    end
  end

  describe "/v1/completions" do
    test "it requires an authorization header bearer token", %{conn: conn} do
      conn =
        conn
        |> post(~p"/api/v1/completions")

      assert conn.status == 401
      assert conn.resp_body =~ "You didn't provide an API key"
    end

    test "it does not 401 when provided a bearer token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/completions")

      assert conn.status != 401
    end

    test "it validates `model` body parameter", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/completions")

      assert conn.status == 400
      assert conn.resp_body =~ "you must provide"
    end

    test "it returns a valid completion", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/completions", %{"model" => "text-davinci-003"})

      assert conn.status == 200
      assert conn.resp_body =~ "I am writing to request"
    end

    test "it supports streaming", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(
          ~p"/api/v1/completions",
          %{
            "model" => "text-davinci-003",
            "stream" => true
          }
        )

      assert conn.status == 200
    end
  end

  describe "/v1/embeddings" do
    test "it requires an authorization header bearer token", %{conn: conn} do
      conn =
        conn
        |> post(~p"/api/v1/embeddings")

      assert conn.status == 401
      assert conn.resp_body =~ "You didn't provide an API key"
    end

    test "it does not 401 when provided a bearer token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/embeddings")

      assert conn.status != 401
    end

    test "it validates `model` body parameter", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/embeddings")

      assert conn.status == 400
      assert conn.resp_body =~ "you must provide"
    end

    test "it returns a valid completion", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer foo")
        |> post(~p"/api/v1/embeddings", %{"model" => "text-davinci-003"})

      assert conn.status == 200
      assert String.length(conn.resp_body) > 10
    end
  end
end
