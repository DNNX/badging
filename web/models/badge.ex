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
    |> cast(params, [:identifier, :subject, :status, :color, :svg])
    |> validate_required([:identifier, :subject, :status, :color])
  end
end
