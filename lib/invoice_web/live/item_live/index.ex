defmodule InvoiceWeb.ItemLive.Index do
  use InvoiceWeb, :live_view
  import Phoenix.Component
  import Phoenix.LiveView.Helpers
  import Phoenix.LiveView, only: [
    stream: 3,
    stream_insert: 3,
    stream_delete: 3,
    put_flash: 3,
    push_navigate: 2
  ]
  import Phoenix.LiveView.Controller, only: [redirect: 2]
  alias Invoice.InvoiceView
  alias Invoice.InvoiceView.Item

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> stream(:items, InvoiceView.list_items())
      |> assign(:total, calculate_total())
      |> assign(:download_path, nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, InvoiceView.get_item!(id))
    |> assign(:total, calculate_total())
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
    |> assign(:total, calculate_total())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Invoice Generator")
    |> assign(:item, nil)
    |> assign(:total, calculate_total())
  end

  @impl true
  def handle_info({InvoiceWeb.ItemLive.FormComponent, {:saved, item}}, socket) do
    {:noreply, stream_insert(socket, :items, item)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = InvoiceView.get_item!(id)
    {:ok, _} = InvoiceView.delete_item(item)

    {:noreply,
      socket
      |> stream_delete(:items, item)
      |> assign(:total, calculate_total())}
  end

  @impl true
  def handle_event("export_pdf", _, socket) do
    items = InvoiceView.list_items()
    total = calculate_total()

    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body {
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
          padding: 40px;
          max-width: 800px;
          margin: 0 auto;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin: 20px 0;
        }
        th {
          background-color: #f4f4f4;
          padding: 12px;
          text-align: left;
          border-bottom: 2px solid #ddd;
        }
        td {
          padding: 12px;
          text-align: left;
          border-bottom: 1px solid #ddd;
        }
        .total {
          margin-top: 30px;
          text-align: right;
          font-size: 18px;
          font-weight: bold;
        }
        .header {
          margin-bottom: 30px;
          border-bottom: 2px solid #eee;
          padding-bottom: 20px;
        }
      </style>
    </head>
    <body>
      <div class="header">
        <h1>Invoice</h1>
        <p>Generated on #{Calendar.strftime(DateTime.utc_now(), "%B %d, %Y")}</p>
      </div>
      <table>
        <thead>
          <tr>
            <th>Description</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          #{for item <- items do
            """
            <tr>
              <td>#{item.description}</td>
              <td>€#{item.price}</td>
              <td>#{item.quantity}</td>
              <td>€#{item.price * item.quantity}</td>
            </tr>
            """
          end}
        </tbody>
      </table>
      <div class="total">
        Total: €#{total}
      </div>
    </body>
    </html>
    """

    # Create a unique directory for each PDF
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    filename = "invoice_#{timestamp}.pdf"
    base_path = Path.join([Application.app_dir(:invoice), "priv", "static", "downloads"])
    pdf_path = Path.join(base_path, filename)

    # Ensure directory exists
    File.mkdir_p!(base_path)

    case ChromicPDF.print_to_pdf(
      {:html, html_content},
      output: pdf_path,
      print_options: %{
        preferCSSPageSize: true,
        displayHeaderFooter: false,
        marginTop: 0.4,
        marginBottom: 0.4,
        marginLeft: 0.4,
        marginRight: 0.4,
        printBackground: true
      }
    ) do
      :ok ->
        # Verify the file exists and is a valid PDF
        case File.read(pdf_path) do
          {:ok, content} ->
            if String.starts_with?(content, "%PDF-") do
              # File exists and appears to be a valid PDF
              download_path = "/downloads/#{filename}"

              {:noreply,
                socket
                |> put_flash(:info, "PDF generated successfully")
                |> assign(:download_path, download_path)}
            else
              {:noreply,
                socket
                |> put_flash(:error, "Generated file is not a valid PDF")}
            end

          {:error, reason} ->
            {:noreply,
              socket
              |> put_flash(:error, "Failed to read generated PDF: #{inspect(reason)}")}
        end

      {:error, reason} ->
        {:noreply,
          socket
          |> put_flash(:error, "Failed to generate PDF: #{inspect(reason)}")}
    end
  end

  defp calculate_total do
    InvoiceView.list_items()
    |> Enum.reduce(0, fn item, acc ->
      acc + (item.price * item.quantity)
    end)
  end
end
