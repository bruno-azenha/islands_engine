defmodule IslandsEngine.IslandSet do
  alias IslandsEngine.{Island, IslandSet}

  defstruct atoll: :none, dot: :none, l_shape: :none, s_shape: :none, square: :none

  def start_link() do
    Agent.start_link(fn -> initialized_set() end)
  end

  def to_string(island_set) do
    "%IslandSet{" <> string_body(island_set) <> "}"
  end

  defp initialized_set() do
    Enum.reduce(keys(), %IslandSet{}, fn(key, set) ->
      {:ok, island} = Island.start_link()
      Map.put(set, key, island)
    end)
  end

  defp keys() do
    %IslandSet{}
    |> Map.from_struct()
    |> Map.keys()
  end

  defp string_body(island_set) do
    keys()
    |> Enum.map(fn(key) -> {key, Agent.get(island_set, &(Map.fetch!(&1, key)))} end)
    |> Enum.map(fn({key, island}) -> "#{key} => #{Island.to_string(island)}" end)
    |> Enum.join("\n")
  end
end
