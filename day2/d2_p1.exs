defmodule D2P1 do
  def run!() do
    File.read!("day-2-input.txt")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> calculate(0)
  end

  defp calculate(data, pos) do
    action = Enum.at(data, pos)

    case action do
      99 ->
        data

      _ ->
        new_val =
          calc_value(
            action,
            get_num(data, pos + 1),
            get_num(data, pos + 2)
          )

        data
        |> List.replace_at(Enum.at(data, pos + 3), new_val)
        |> calculate(pos + 4)
    end
  end

  defp get_num(data, pos) do
    value_pos = Enum.at(data, pos)
    Enum.at(data, value_pos)
  end

  defp calc_value(1, first, second) do
    first + second
  end

  defp calc_value(2, first, second) do
    first * second
  end
end

D2P1.run!()
|> Enum.at(0)
|> IO.puts()
