# OTP GenServer

This is an example how you can keep a state in elixir,
inspired by the book Learn you some Erlang for great good! (Chapter 14)
here I am using dogs instead of cats :)

## A doggie shop (the state)

In this example, I have implemented a doggie shop.
A doggie shop has dogs (you didn't expect that)

- you can order one
- you can return one

So, here the state are dogs (a list of them) that we want
to keep

## A dog

We need to represent a dog with three attributes:

- name
- color
- description

In elixir, we can represent one by using structs:

```elixir
defmodule Dog do
  defstruct name: nil, color: nil, description: nil

  def make_dog(name, color, description) do
    %Dog{name: name, color: color, description: description}
  end
end
```

So, if you want to make a dog just call the make_dog function

## Open a the shop

The doggie shop just opened, we don't have any orders,
which means that the order list is empty
Let's open the shop by using the OTP GenServer

```elixir
def open_doggie_shop() do
    GenServer.start_link(DoggieServer, [], name: :doggie_shop)
end
```

The above function calls the init function in the module DoggieServer
with an empty list as an argument and spawns a new process named :doggie_shop

```elixir
defmodule DoggieServer do
  use GenServer

  def init(doggies), do: {:ok, doggies}
```

Now we have initialized the state to an empty list
