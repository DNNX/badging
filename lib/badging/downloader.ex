defmodule Badging.Downloader do
  @moduledoc """
  Badging.Downloader provides a utility function `Badging.Dowloader.download/1`
  which makes an HTTP GET request by a given URL and returns response body.
  """

  @doc ~S"""
  Downloads a given URL and returns response body as a binary.
  Fails if response code is not 200.

  ## Examples:

    iex> {:ok, _pid} = HelloWorldWebServer.start(8081)
    iex> Badging.Downloader.download("http://localhost:8081/greet")
    "Hello, World!"

  """
  def download(url) do
    {:ok, {{_, 200, 'OK'}, _headers, body}} = get(url)
    body
  end

  defp get(url) do
    :httpc.request(:get, {to_char_list(url), []}, [], [body_format: :binary])
  end
end
