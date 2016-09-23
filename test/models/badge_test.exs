defmodule Badging.BadgeTest do
  use Badging.ModelCase

  alias Badging.Badge

  @valid_attrs %{color: "some content", identifier: "some content", status: "some content", subject: "some content", svg: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Badge.changeset(%Badge{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Badge.changeset(%Badge{}, @invalid_attrs)
    refute changeset.valid?
  end
end
