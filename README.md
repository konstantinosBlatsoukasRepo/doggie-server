# Doggie shop (OTP GenServer)

This is an example how you can keep a state in elixir,
inspired by the book Learn you some Erlang for great good! (Chapter 14)
here I am using dogs instead of cats :)

## Sections

- [The Doggie Shop](#The-doggie-shop)
- [Dog Representation](#dog-representation)
- [Open The Shop / Process Initialization](#open-the-shop-/-process-initialization)
- [Order A Dog / A Synchronous Call](#order-a-dog-/-a-synchronous-call)
- [Return A Dog / An Asynchronous Call](return-a-dog-/-an-asynchronous-call)

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

## Open The Shop / Process Initialization

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

The shop is just a process that is able to hold a state, here I have also gave a name to the process
:doggie_shop (the third argument of the GenServer.start_link/3)

---

## Order A Dog / A Synchronous Call

It's time to order a dog
The API offers a function order_dog/4:

```elixir
def order_dog(doggie_shop, name, color, description) do
    GenServer.call(doggie_shop, {:order_dog, name, color, description})
end
```

The order_dog/4 internally invokes the GenServer.call/3 (the third argument is optional, for more info see [GenServer](https://hexdocs.pm/elixir/GenServer.html#call/3))

What happens when we invoke GenServer.call/3:

- a _message_ (third argument of GenServer.call/3) is sent to a _process_ (first argument of GenServer.call/3)
  and a _response is expected_ from the process (first argument GenServer.call/3)
- **the message**

  In our case the message is going to have the form of

  ```elixir
    {:order_dog, name, color, description}
  ```

- **the process that we are sending the message (responsible for handling the message)**

  When we opened the shop by using the

  ```elixir
  GenServer.start_link(DoggieServer, [], name: :doggie_shop)
  ```

  we started a process with a name :doggie_shop (third argument GenServer.start_link/3),
  so the process has a name :doggie_shop (and you can send a message to that process by using that name)

- **synchronous call**

  by using the GenServer.call/3 we are expecting a response in a synchronous way (a blocking operation, I am not going anywhere if I don't have my response)

now we have sent the order let's handle it!

- **handling the the order/message**

  All the message handling (state initialization and the state manipulation) is happening in the DoggieServer module.

  The message handling of the form {:order_dog, name, color, description} happens in the function DoggieServer.handle_call/3

  ```elixir
  defmodule DoggieServer do
    use GenServer

    def init(doggies), do: {:ok, doggies}

    def handle_call({:order_dog, name, color, description}, _, doggies) do
      case doggies do
        [] -> {:reply, Dog.make_dog(name, color, description), doggies}
        [doggie | rest_doggies] -> {:reply, doggie, rest_doggies}
      end
    end
  end
  ```

  let's break down the handle_call/3

  - handle_call/3 is used when you need a synchronous communication (you taking the message and you have to retrurn a response)
  - the first argument is the message form that the function can handle (in this example {:order_dog, name, color, description})
  - the second argument is ID for the process (which we are not interested in that case)
  - the third argument is current the state of the process, here is the list of dogs
  - the reply must be in the form {:reply, reply, new_state} (there are more options see [handle_call/3](https://hexdocs.pm/elixir/GenServer.html#c:handle_call/3))
  - reply: is the response that to the message sender
  - new_state: here the state is updated to new_state

  Let's demonastrate an order!

  1. Open the shop / process initialization

     ```elixir
     iex(2)> DoggieApi.open_doggie_shop
     {:ok, #PID<0.133.0>}
     ```

     now we have opened a shop with no dogs (e.g. the state is an empty list)

  2. Order a dog / synchronous call
     ```elixir
     iex(4)> DoggieApi.order_dog(:doggie_shop, "Rex", "White", "A cool dog")
     %Dog{color: "White", description: "A cool dog", name: "Rex"}
     ```
     We got back what we have ordered, that happened since the dog list was empty (e.g. the state wasn't modified, the only way to modify the state is to return a dog or let all the dogs out! stay tuned)
