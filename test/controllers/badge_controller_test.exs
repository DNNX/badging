defmodule Badging.BadgeControllerTest do
  use Badging.ConnCase

  alias Badging.Badge
  @valid_attrs %{color: "some content", identifier: "some content", status: "some content", subject: "some content", svg: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, badge_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    badge = Repo.insert! %Badge{}
    conn = get conn, badge_path(conn, :show, badge)
    assert json_response(conn, 200)["data"] == %{"id" => badge.id,
      "identifier" => badge.identifier,
      "subject" => badge.subject,
      "status" => badge.status,
      "color" => badge.color,
      "svg" => badge.svg}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, badge_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, badge_path(conn, :create), badge: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Badge, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, badge_path(conn, :create), badge: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    badge = Repo.insert! %Badge{}
    conn = put conn, badge_path(conn, :update, badge), badge: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Badge, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    badge = Repo.insert! %Badge{}
    conn = put conn, badge_path(conn, :update, badge), badge: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    badge = Repo.insert! %Badge{}
    conn = delete conn, badge_path(conn, :delete, badge)
    assert response(conn, 204)
    refute Repo.get(Badge, badge.id)
  end
end
