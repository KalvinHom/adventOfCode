defmodule D3P1 do
  def run!() do
    [line1, line2] =
      File.read!("day-3-input.txt")
      |> String.split("\n", trim: true)

    line1 = String.split(line1, ",", trim: true)
    line2 = String.split(line2, ",", trim: true)

    %{point_lengths: line1_points} = build_points(line1)
    %{point_lengths: line2_points} = build_points(line2)

    intersections =
      MapSet.intersection(
        Enum.into(Map.keys(line1_points), MapSet.new()),
        Enum.into(Map.keys(line2_points), MapSet.new())
      )
      |> MapSet.to_list()

    Enum.map(
      intersections,
      &(Map.get(line1_points, &1) + Map.get(line2_points, &1))
    )
    |> Enum.min()
  end

  defp build_points(coords) do
    points = %{last_point: {0, 0}, last_len: 0, point_lengths: %{}}

    Enum.reduce(coords, points, fn coord, acc ->
      build_point(acc, coord)
    end)
  end

  defp build_point(%{last_point: {x, y}, last_len: last_len, point_lengths: point_lengths}, coord) do
    {dir, len} = String.split_at(coord, 1)
    len = String.to_integer(len)

    case dir do
      r when r == "R" ->
        %{
          last_point: {x + len, y},
          last_len: last_len + len,
          point_lengths:
            Enum.reduce(len..1, point_lengths, fn i, acc ->
              insert_point(acc, {x + i, y}, last_len, i)
            end)
        }

      r when r == "L" ->
        %{
          last_point: {x - len, y},
          last_len: last_len + len,
          point_lengths:
            Enum.reduce(len..1, point_lengths, fn i, acc ->
              insert_point(acc, {x - i, y}, last_len, i)
            end)
        }

      r when r == "U" ->
        %{
          last_point: {x, y + len},
          last_len: last_len + len,
          point_lengths:
            Enum.reduce(len..1, point_lengths, fn i, acc ->
              insert_point(acc, {x, y + i}, last_len, i)
            end)
        }

      r when r == "D" ->
        %{
          last_point: {x, y - len},
          last_len: last_len + len,
          point_lengths:
            Enum.reduce(len..1, point_lengths, fn i, acc ->
              insert_point(acc, {x, y - i}, last_len, i)
            end)
        }
    end
  end

  defp insert_point(points, point, length, increment) do
    case Map.has_key?(points, point) do
      true -> points
      false -> Map.put(points, point, length + increment)
    end
  end
end

D3P1.run!()
|> IO.puts()
