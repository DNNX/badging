defmodule Badging.BadgeController do
  use Badging.Web, :controller

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

  def show(conn, %{"id" => id}) do
    badge = Repo.get!(Badge, id)
    render(conn, "show.json", badge: badge)
  end

  def update(conn, %{"id" => id, "badge" => badge_params}) do
    badge = Repo.get!(Badge, id)
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

  def delete(conn, %{"id" => id}) do
    badge = Repo.get!(Badge, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(badge)

    send_resp(conn, :no_content, "")
  end
end
