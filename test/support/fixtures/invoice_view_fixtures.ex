defmodule Invoice.InvoiceViewFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Invoice.InvoiceView` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        description: "some description",
        price: 42,
        quantity: 42
      })
      |> Invoice.InvoiceView.create_item()

    item
  end
end
