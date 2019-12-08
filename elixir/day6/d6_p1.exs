defmodule D6P1 do
  def run!() do
    File.read!("day-6-input.txt")
    |> String.split("\n", trim: true)
    |> get_orbits()
    |> count_orbits()
    |> Enum.sum()
  end

  def get_orbits(data) do
    Enum.reduce(data, %{}, fn orbit, acc ->
      <<parent::binary-size(3), ")", orbiter::binary-size(3)>> = orbit
      Map.put(acc, orbiter, parent)
    end)
  end

  defp count_orbits(orbits) do
    Enum.map(Map.keys(orbits), fn orbit ->
      count_orbit(orbits, orbit)
    end)
  end

  defp count_orbit(orbits, orbit) do
    case Map.get(orbits, orbit) do
      nil -> 0
      parent -> 1 + count_orbit(orbits, parent)
    end
  end
end

Benchee.run(%{
  "d6 p1" => fn ->
    D6P1.run!()
    |> IO.puts()
  end
})
