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

1. Clone repo
2. Run `mix deps.get`
3. Run `mix phx.server` and go to http://localhost:4000
4. Go to http://localhost:4000/items
  - Create a line item
  - See the total
5. Click export as PDF
  - View file in `/priv/static/downloads`

## Notes

Refer to commit [0c78732](https://github.com/simonbeirouti/invoice-gen/tree/0c78732f1f551c302731d40074afa3663a6376ba) to see the submitted code

Current merged commit is the working code