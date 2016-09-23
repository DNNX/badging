defmodule Badging.Repo.Migrations.CreateBadge do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add :identifier, :string
      add :subject, :string
      add :status, :string
      add :color, :string
      add :svg, :string

      timestamps()
    end

  end
end
