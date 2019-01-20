defmodule DoggieServer do
  use GenServer

  def init(doggies), do: {:ok, doggies}

  def handle_call({:order_dog, name, color, description}, _, doggies) do
    case doggies do
      [] -> {:reply, Dog.make_dog(name, color, description), doggies}
      [doggie | rest_doggies] -> {:reply, doggie, rest_doggies}
    end
  end

  def handle_call({:let_the_dogs_out}, arg, doggies) do
    case doggies do
      [] ->
        {:reply, "There are no dogs in the shop", doggies}

      [doggie | rest_doggies] ->
        IO.puts(doggie.name <> " is out!")
        handle_call({:let_the_dogs_out}, arg, rest_doggies)
    end
  end

  def handle_cast({:return_dog, doggie}, doggies) do
    {:noreply, [doggie | doggies]}
  end
end
