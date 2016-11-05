defmodule Badging.TokenAuthTest do
  use Badging.ConnCase

  test "with valid token" do
    auth_token = "s3cre5"

    conn =
      build_conn(:get, "/?token=" <> auth_token)
      |> Plug.Conn.fetch_query_params
      |> pipe_through_plug(Badging.TokenAuth, auth_token)

    refute conn.halted
    assert conn.status != 403
  end

  test "with invalid token" do
    auth_token = "s3cre5"

    conn =
      build_conn(:get, "/?token=XYZXYZ" <> auth_token)
      |> Plug.Conn.fetch_query_params
      |> pipe_through_plug(Badging.TokenAuth, auth_token)

    assert conn.halted
    assert conn.status == 403
  end

  test "without token" do
    auth_token = "s3cre5"

    conn =
      build_conn(:get, "/")
      |> Plug.Conn.fetch_query_params
      |> pipe_through_plug(Badging.TokenAuth, auth_token)

    assert conn.halted
    assert conn.status == 403
  end

  defp pipe_through_plug(conn, plug, plug_opts) do
    plug_state = plug.init(plug_opts)
    plug.call(conn, plug_state)
  end
end
