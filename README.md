# Doggie shop (OTP GenServer)

This is an example how you can keep a state in elixir,
inspired by the book Learn you some Erlang for great good! (Chapter 14)
here I am using dogs instead of cats :)


## Sections
- [The Doggie Shop](#The-doggie-shop)
- [Dog Representation](#dog-representation)
- [Open the shop](#open-the-shop)

---
## The Doggie Shop

A doggie shop has dogs (you didn't expect that)

What you can do in the shop:

- you can order one
- you can return one

So, here the state are dogs (a list of them) that we want
to keep

---
## Dog Representation

Dog has the following attributes (probably has more but let's keep it simple)

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

So, if you want a new dog just call the make_dog/3
For example:

```elixir
iex(2)> max = Dog.make_dog("Max", "Black", "A really strong dog")
%Dog{color: "Black", description: "A really strong dog", name: "Max"}
```
We just created the max! a strong dog!

---

## Open the shop

Let's open the shop

```elixir
def open_doggie_shop() do
    GenServer.start_link(DoggieServer, [], name: :doggie_shop)
end
```
Let's explain what is happening in the above call:

 - As you can see the GenServer.start_link/3 is invoked 
 - This function **spawns a new process**
 - The first argument is the module which is responsible to handle 
  the state (the initialization, synchronous calls, asynchronous calls etc.)  
 - The second argument is the value that we pass in the function that initializes
 the state (this function is called init)
 - the third argument is optional, here we have named the new process :doggie_shop

By calling the GenServer.start_link/3 the init/1 in DoggieServer is invoked as well.

**the init is reponsible for the state initialization**, in the DoggieServer init
accepts the second argument of the GenServer.start_link/3 as an initial state
(just an empty list) 

```elixir
defmodule DoggieServer do
  use GenServer

  def init(doggies), do: {:ok, doggies}

end
```

let's open the shop to see what happens

```elixir
iex(1)> DoggieApi.open_doggie_shop()
{:ok, #PID<0.143.0>}
```

The shop is just a process that can holds a state, here I have also gave a name to the process
:doggie_shop (the third argument of the GenServer.start_link/3)

---