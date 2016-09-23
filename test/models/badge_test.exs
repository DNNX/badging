defmodule Badging.BadgeTest do
  use Badging.ModelCase, async: true

  alias Badging.Badge

  @valid_attrs %{
    color: "yellow",
    identifier: "coverage",
    status: "83%",
    subject: "Test Coverage"
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Badge.changeset(%Badge{}, @valid_attrs)
    assert changeset.valid?
  end

  test "validates identifier presence" do
    changeset = Badge.changeset(%Badge{}, Map.put(@valid_attrs, :identifier, ""))
    refute changeset.valid?
  end
end
