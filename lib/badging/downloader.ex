defmodule Badging.Downloader do
  @doc ~S"""
  Downloads a given URL and returns response body as a binary.

  ## Examples:

    iex> {:ok, _pid} = HelloWorldWebServer.start(8081)
    iex> Badging.Downloader.download("http://localhost:8081/greet")
    "Hello, World!"

  """
  def download(url) do
    {:ok, resp} = :httpc.request(:get, {to_char_list(url), []}, [], [body_format: :binary])
    {{_, 200, 'OK'}, _headers, body} = resp
    body
  end
end
