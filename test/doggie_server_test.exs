defmodule DoggieServerTest do
  use ExUnit.Case
  doctest DoggieServer

  test "greets the world" do
    assert DoggieServer.hello() == :world
  end
end
