defmodule HelloWorldWebServer do
  @moduledoc """
  HelloWorldWebServer is a simple web server which
  always responds with 200 OK, Hello, World!
  It is used to test the downloader.
  """

  def start(port) do
    args = [
      bind_address: 'localhost',
      port: port,
      ipfamily: :inet,
      modules: [__MODULE__],
      server_name: 'Hello World',
      server_root: '.',
      document_root: '.'
    ]
    :inets.start(:httpd, args, :stand_alone)
  end

  def unquote(:do)(_data) do
    {:proceed, [{:response, {200, 'Hello, World!'}}]}
  end
end
