defmodule Badging.Badge do
  use Badging.Web, :model

  @moduledoc """
  Badging.Badge is a core model of the application. It represents an information
  about a badge: its subject, status and color along with SVG generated basing
  on these attributes.
  """

  @derive {Phoenix.Param, key: :identifier}
  schema "badges" do
    field :identifier, :string
    field :subject, :string
    field :status, :string
    field :color, :string
    field :svg, :string
    field :svg_downloaded_at, :utc_datetime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:identifier, :subject, :status, :color])
    |> validate_required([:identifier, :subject, :status, :color])
    |> unique_constraint(:identifier)
  end

  @doc """
  Builds a changeset with SVG data. Validates :svg presence, sets
  :svg_downloaded_at automatically to current time.
  """
  def svg_changeset(struct, params) do
    struct
    |> cast(params, [:svg, :svg_downloaded_at])
    |> put_change(:svg_downloaded_at, DateTime.utc_now)
    |> validate_required([:svg])
  end

  @doc """
  Generates a shields.io URL to the SVG badge.

  ## Examples

      iex> Badging.Badge.shieldsio_url(%Badging.Badge{
      ...>   subject: "RSpec To Minitest Migration",
      ...>   color: "yellow",
      ...>   status: "almost_done (99%)"
      ...> })
      "https://img.shields.io/badge/" <>
        "RSpec_To_Minitest_Migration-almost__done_(99%25)-yellow.svg"
  """
  def shieldsio_url(%__MODULE__{subject: subject, status: status, color: color})
    when is_binary(subject) and is_binary(status) and is_binary(color) do
    "https://img.shields.io/badge/" <>
      "#{escape subject}-#{escape status}-#{escape color}.svg"
  end

  defp escape(str) do
    str
    |> String.replace("-", "--")
    |> String.replace("_", "__")
    |> String.replace(" ", "_")
    |> URI.encode
  end
end
