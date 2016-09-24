defmodule Badging.Downloader do
  @doc ~S"""
  Downloads a given URL and returns response body as a binary.

  ## Examples:

    iex> Badging.Downloader.download("https://gist.githubusercontent.com/DNNX/6700de6ad99f87b16398ddb73446bdaa/raw/ca257e60b55cf8c9f0952119c90f3bd7828ddb07/test.txt")
    "this is a test"
  """
  def download(url) do
    {:ok, resp} = :httpc.request(:get, {to_char_list(url), []}, [], [body_format: :binary])
    {{_, 200, 'OK'}, _headers, body} = resp
    body
  end
end
