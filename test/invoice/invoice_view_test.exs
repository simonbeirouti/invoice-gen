defmodule Invoice.InvoiceViewTest do
  use Invoice.DataCase

  alias Invoice.InvoiceView

  describe "items" do
    alias Invoice.InvoiceView.Item

    import Invoice.InvoiceViewFixtures

    @invalid_attrs %{description: nil, price: nil, quantity: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert InvoiceView.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert InvoiceView.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{description: "some description", price: 42, quantity: 42}

      assert {:ok, %Item{} = item} = InvoiceView.create_item(valid_attrs)
      assert item.description == "some description"
      assert item.price == 42
      assert item.quantity == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = InvoiceView.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{description: "some updated description", price: 43, quantity: 43}

      assert {:ok, %Item{} = item} = InvoiceView.update_item(item, update_attrs)
      assert item.description == "some updated description"
      assert item.price == 43
      assert item.quantity == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = InvoiceView.update_item(item, @invalid_attrs)
      assert item == InvoiceView.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = InvoiceView.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> InvoiceView.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = InvoiceView.change_item(item)
    end
  end
end
