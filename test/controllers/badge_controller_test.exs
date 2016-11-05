defmodule Badging.BadgeControllerTest do
  use Badging.ConnCase

  alias Badging.Badge

  @valid_attrs %{
    identifier: "conversion",
    color: "yellow",
    status: "83%",
    subject: "Conversion Progress"
  }
  @invalid_attrs %{color: ""}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get_authenticated(conn, "/badges")

    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    badge = Repo.insert! valid_badge

    conn = get_authenticated(conn, "/badges/coverage")

    assert json_response(conn, 200)["data"] == %{
      "id" => badge.id,
      "identifier" => badge.identifier,
      "subject" => badge.subject,
      "status" => badge.status,
      "color" => badge.color,
      "svg" => badge.svg
    }
  end

  test "renders SVG when it's available", %{conn: conn} do
    Repo.insert! valid_badge_with_svg

    conn = get_authenticated(conn, "/badges/coverage.svg")

    assert conn.resp_body == "<svg />"
    assert get_header(conn, "content-type") == "image/svg+xml"
  end

  test "renders 403 when not authed", %{conn: conn} do
    Repo.insert! valid_badge_with_svg

    conn = get(conn, "/badges/coverage.svg")

    assert conn.status == 403
    assert conn.resp_body == "Forbidden"
  end

  test "renders 404 when SVG is not available", %{conn: conn} do
    Repo.insert! valid_badge

    assert_error_sent 404, fn ->
      get_authenticated(conn, "/badges/coverage.svg")
    end
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get_authenticated(conn, "/badges/dont_exist.svg")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn =
      conn
      |> authenticated(:write_auth)
      |> post("/badges", badge: @valid_attrs)

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Badge, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn =
      conn
      |> authenticated(:write_auth)
      |> post("/badges", badge: @invalid_attrs)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    Repo.insert! valid_badge

    conn =
      conn
      |> authenticated(:write_auth)
      |> put("/badges/coverage", badge: @valid_attrs)

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Badge, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
     Repo.insert! valid_badge

    conn =
      conn
      |> authenticated(:write_auth)
      |> put("/badges/coverage", badge: @invalid_attrs)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    Repo.insert! valid_badge

    conn =
      conn
      |> authenticated(:write_auth)
      |> delete("/badges/coverage")

    assert response(conn, 204)
    refute Repo.one(Badge, identifier: "coverage")
  end

  defp valid_badge do
    %Badge{
      identifier: "coverage",
      subject: "Coverage",
      status: "83%",
      color: "yellow"
    }
  end

  defp valid_badge_with_svg do
    %Badge{
      identifier: "coverage",
      subject: "Coverage",
      status: "83%",
      color: "yellow",
      svg: "<svg />",
      svg_downloaded_at: now
    }
  end

  defp get_header(conn, header_name) do
    conn.resp_headers
    |> Enum.find_value(fn
      {^header_name, value} -> value
      _ -> nil
    end)
  end

  defp now do
    Ecto.DateTime.from_erl(:calendar.universal_time)
  end

  defp authenticated(conn, auth_key) do
    config = Application.get_env(:badging, auth_key)
    username = Keyword.fetch!(config, :username)
    password = Keyword.fetch!(config, :password)

    header_content = "Basic " <> Base.encode64("#{username}:#{password}")

    put_req_header(conn, "authorization", header_content)
  end

  defp get_authenticated(conn, path) do
    read_auth_token = Application.get_env(:badging, :read_auth_token)
    get(conn, path, token: read_auth_token)
  end
end
