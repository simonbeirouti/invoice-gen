# Invoice

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Instructions

Create an invoice generator:
- A single liveview where I can add line items with a description, price and quantity
- It should calculate a total at the bottom
- It should have an “Export as PDF” that downloads it as a PDF

## Notes

Refer to commit [0c78732](https://github.com/simonbeirouti/invoice-gen/tree/0c78732f1f551c302731d40074afa3663a6376ba) to see the submitted code

Current merged commit is the working code