defmodule Badging.Badge do
  use Badging.Web, :model

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
  end

  @doc """
  Builds a changeset with SVG data. Validates :svg presence, sets
  :svg_downloaded_at automatically to current time.
  """
  def svg_changeset(struct, params) do
    struct
    |> cast(params, [:svg])
    |> validate_required([:svg])
    |> put_change(:svg_updated_at, Ecto.DateTime.utc(:usec))
  end
end
