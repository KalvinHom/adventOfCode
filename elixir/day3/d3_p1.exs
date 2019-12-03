defmodule D3P1 do
  def run!() do
    [line1, line2] =
      File.read!("day-3-input.txt")
      |> String.split("\n", trim: true)

    line1 = String.split(line1, ",", trim: true)
    line2 = String.split(line2, ",", trim: true)

    line1_points = build_points(line1)
    line2_points = build_points(line2)

    MapSet.intersection(
      Enum.into(line1_points, MapSet.new()),
      Enum.into(line2_points, MapSet.new())
    )
    |> MapSet.delete({0, 0})
    |> MapSet.to_list()
    |> Enum.map(&calc_distance/1)
    |> Enum.min()
  end

  defp build_points(coords) do
    list = [{0, 0}]

    Enum.reduce(coords, list, fn coord, acc ->
      build_point(acc, coord) ++ acc
    end)
  end

  defp build_point(list, coord) do
    {dir, len} = String.split_at(coord, 1)
    len = String.to_integer(len)
    {x, y} = hd(list)

    case dir do
      r when r == "R" -> Enum.map(len..1, fn i -> {x + i, y} end)
      r when r == "L" -> Enum.map(len..1, fn i -> {x - i, y} end)
      r when r == "U" -> Enum.map(len..1, fn i -> {x, y + i} end)
      r when r == "D" -> Enum.map(len..1, fn i -> {x, y - i} end)
    end
  end

  defp calc_distance({x, y}) do
    abs(x) + abs(y)
  end
end

D3P1.run!()
|> IO.puts()
