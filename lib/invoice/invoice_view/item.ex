defmodule Invoice.InvoiceView.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :description, :string
    field :price, :integer
    field :quantity, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:description, :price, :quantity])
    |> validate_required([:description, :price, :quantity])
  end
end
