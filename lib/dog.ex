defmodule Dog do
  defstruct name: nil, color: nil, description: nil

  def make_dog(name, color, description) do
    %Dog{name: name, color: color, description: description}
  end
end
