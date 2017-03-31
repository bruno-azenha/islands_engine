defmodule IslandsEngine.Island do
  alias IslandsEngine.Island

  def start_link() do
    Agent.start_link(fn -> [] end)
  end

  def replace_coordinates(island, new_coordinates) when is_list(new_coordinates) do
    Agent.update(island, fn _state -> new_coordinates end)
  end

  def forested?(island) do
    Agent.get(island, fn state -> state end)
    |> Enum.all(fn coord -> Coordinate.hit?(coord) end)
  end

  def to_string(island) do
    island_string =
      Agent.get(island, fn state -> state end)
      |> Enum.map(fn coord -> IslandsEngine.Coordinate.to_string(coord) end)
      |> Enum.join(", ")
    "[" <> island_string <> "]"
  end
end
