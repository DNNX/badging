defmodule Badging.TokenAuth do
  import Plug.Conn

  @moduledoc """
  Badging.TokenAuth is a plug that implements very simple "authentication" via
  `token` param. It should not be used for anything serious.

  Basic usage is this:

  ```
  plug Badging.TokenAuth, "s3cr5t"
  ```

  Now, if the request is sent with query param `token=s3cr5t`, then it will be
  allowed. Otherwise, `conn` is halted and 403 Forbidden is sent.
  """

  def init(token) when is_binary(token) do
    token
  end

  def call(conn, token) do
    case conn.params["token"] do
      ^token -> conn
      _ ->
        conn
        |> send_resp(403, "Forbidden")
        |> halt
    end
  end
end
