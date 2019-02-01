defmodule Badging.Repo.Migrations.CreateBadge do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add(:identifier, :string, null: false)
      add(:subject, :string, null: false)
      add(:status, :string, null: false)
      add(:color, :string, null: false)
      add(:svg, :text)
      add(:svg_downloaded_at, :utc_datetime_usec)

      timestamps()
    end

    create(unique_index(:badges, [:identifier]))
  end
end
