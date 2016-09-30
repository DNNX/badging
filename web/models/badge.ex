defmodule Badging.Badge do
  use Badging.Web, :model

  @derive {Phoenix.Param, key: :identifier}
  schema "badges" do
    field :identifier, :string
    field :subject, :string
    field :status, :string
    field :color, :string
    field :svg, :string
    field :svg_downloaded_at, Ecto.DateTime

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
    |> put_change(:svg_downloaded_at, Ecto.DateTime.utc(:usec))
    |> validate_required([:svg])
  end

  def shieldsio_url(%__MODULE__{subject: subject, status: status, color: color})
    when is_binary(subject) and is_binary(status) and is_binary(color) do
    "https://img.shields.io/badge/#{escape subject}-#{escape status}-#{escape color}.svg"
  end

  defp escape(str) do
    str
    |> String.replace("-", "--")
    |> String.replace("_", "__")
    |> String.replace(" ", "_")
  end
end
