defmodule D6P2 do
  def run!() do
    File.read!("day-6-input.txt")
    |> String.split("\n", trim: true)
    |> get_orbits()
    |> find_san()
  end

  defp get_orbits(data) do
    Enum.reduce(data, %{}, fn orbit, acc ->
      <<parent::binary-size(3), ")", orbiter::binary-size(3)>> = orbit
      Map.put(acc, orbiter, parent)
    end)
  end

  defp get_distances(orbits, orbit, distances, distance) do
    case Map.get(orbits, orbit) do
      nil -> Map.put(distances, orbit, distance)
      parent -> get_distances(orbits, parent, Map.put(distances, orbit, distance), 1 + distance)
    end
  end

  defp get_distance_to_san(orbits, orbit, san_distances) do
    case Map.get(san_distances, orbit) do
      nil -> 1 + get_distance_to_san(orbits, Map.get(orbits, orbit), san_distances)
      x -> x
    end
  end

  defp find_san(orbits) do
    san_distances = get_distances(orbits, Map.get(orbits, "SAN"), %{}, 0)
    start_orbit = Map.get(orbits, "YOU")
    get_distance_to_san(orbits, start_orbit, san_distances)
  end
end

D6P2.run!()
|> IO.inspect()
