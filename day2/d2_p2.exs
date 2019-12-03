defmodule D2P2 do
  def run!() do
    File.read!("day-2-input.txt")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> recursive_calc(0, 0)
  end

  defp recursive_calc(data, noun, verb) do
    {noun, verb} =
      case verb do
        100 -> {noun + 1, 0}
        _ -> {noun, verb}
      end

    val =
      data
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)
      |> calculate(0)
      |> Enum.at(0)

    case val do
      19_690_720 -> {noun, verb}
      _ -> recursive_calc(data, noun, verb + 1)
    end
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

{noun, verb} = D2P2.run!()

IO.puts(100 * noun + verb)
