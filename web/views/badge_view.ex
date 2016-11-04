defmodule Badging.BadgeView do
  use Badging.Web, :view

  def render("index.json", %{badges: badges}) do
    %{data: render_many(badges, Badging.BadgeView, "badge.json")}
  end

  def render("show.json", %{badge: badge}) do
    %{data: render_one(badge, Badging.BadgeView, "badge.json")}
  end

  def render("badge.json", %{badge: badge}) do
    %{id: badge.id,
      identifier: badge.identifier,
      subject: badge.subject,
      status: badge.status,
      color: badge.color,
      svg: badge.svg
    }
  end
end
