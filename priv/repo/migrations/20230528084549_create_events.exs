defmodule CalendarApp.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :date, :date, null: false
      add :name, :string, null: false, default: "", size: 32

      timestamps()
    end
  end
end
