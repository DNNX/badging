defmodule Badging.Badge do
  use Badging.Web, :model

  schema "badges" do
    field :identifier, :string
    field :subject, :string
    field :status, :string
    field :color, :string
    field :svg, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:identifier, :subject, :status, :color, :svg])
    |> validate_required([:identifier, :subject, :status, :color, :svg])
  end
end
