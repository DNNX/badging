defmodule Badging.StubbedDownloader do
  @moduledoc """
  Badging.StubbedDownloader is a version of Badging.Downloader that is used for
  tests only.
  """
  def download("https://img.shields.io/badge/Conversion_Progress-83%-yellow.svg") do
    "<svg/>"
  end
end
