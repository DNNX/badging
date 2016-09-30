defmodule Badging.BadgeController do
  use Badging.Web, :controller

  @write_actions [:create, :update, :delete]

  plug BasicAuth, Application.get_env(:badging, :read_auth) when not action in @write_actions
  plug BasicAuth, Application.get_env(:badging, :write_auth) when action in @write_actions

  alias Badging.Badge

  def index(conn, _params) do
    badges = Repo.all(Badge)
    render(conn, "index.json", badges: badges)
  end

  def create(conn, %{"badge" => badge_params}) do
    changeset = Badge.changeset(%Badge{}, badge_params)

    case Repo.insert(changeset) do
      {:ok, badge} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", badge_path(conn, :show, badge))
        |> render("show.json", badge: badge)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Badging.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => identifier}) do
    if String.ends_with?(identifier, ".svg") do
      respond_with_svg(conn, String.trim_trailing(identifier, ".svg"))
    else
      respond_with_json(conn, identifier)
    end
  end

  defp respond_with_svg(conn, badge_identifier) do
    badge = Repo.one!(
      from b in Badge,
      where: not(is_nil(b.svg)) and b.identifier == ^badge_identifier,
      select: struct(b, [:svg, :svg_downloaded_at]))

    conn
    |> put_resp_content_type("image/svg+xml", nil)
    |> send_resp(200, badge.svg)
  end

  defp respond_with_json(conn, badge_identifier) do
    badge = Repo.get_by!(Badge, identifier: badge_identifier)

    render(conn, "show.json", badge: badge)
  end

  def update(conn, %{"id" => identifier, "badge" => badge_params}) do
    badge = Repo.get_by!(Badge, identifier: identifier)
    changeset = Badge.changeset(badge, badge_params)

    case Repo.update(changeset) do
      {:ok, badge} ->
        render(conn, "show.json", badge: badge)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Badging.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => identifier}) do
    badge = Repo.get_by!(Badge, identifier: identifier)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(badge)

    send_resp(conn, :no_content, "")
  end
end
