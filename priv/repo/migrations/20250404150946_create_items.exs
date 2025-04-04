defmodule Invoice.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :description, :string
      add :price, :integer
      add :quantity, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
