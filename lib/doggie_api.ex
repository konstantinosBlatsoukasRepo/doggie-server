defmodule DoggieApi do
  def open_doggie_shop() do
    GenServer.start_link(DoggieServer, [], name: :doggie_shop)
  end

  def order_dog(doggie_shop, name, color, description) do
    GenServer.call(doggie_shop, {:order_dog, name, color, description})
  end

  def return_dog(doggie_shop, doggie) do
    GenServer.cast(doggie_shop, {:return_dog, doggie})
  end

  def let_the_dogs_out(doggie_shop) do
    GenServer.call(doggie_shop, {:let_the_dogs_out})
  end
end
