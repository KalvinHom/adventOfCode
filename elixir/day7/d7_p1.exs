defmodule D7P1 do
  def run!() do
    operations =
      File.read!("day-7-input.txt")
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    input_options = permutations([0, 1, 2, 3, 4])

    Enum.map(input_options, fn input ->
      Enum.reduce(input, 0, fn i, acc ->
        %{output: output} = calculate(operations, 0, %{input: [i, acc]})
        output
      end)
    end)
    |> Enum.max()
  end

  defp calculate(data, pos, input) do
    instruction =
      data
      |> Enum.at(pos)
      |> Integer.digits()
      |> pad_instruction()

    [_third_mode, second_mode, first_mode, opcode1, opcode2] = instruction
    opcode = Integer.undigits([opcode1, opcode2])

    case opcode do
      99 ->
        input

      3 ->
        {data, input} =
          data
          |> set_input(pos + 1, input)

        calculate(data, pos + 2, input)

      4 ->
        input =
          data
          |> output_value(pos + 1, input)

        calculate(data, pos + 2, input)

      5 ->
        new_pos = jump_true(data, first_mode, second_mode, pos)
        calculate(data, new_pos, input)

      6 ->
        new_pos = jump_false(data, first_mode, second_mode, pos)
        calculate(data, new_pos, input)

      7 ->
        data
        |> less_than_op(first_mode, second_mode, pos)
        |> calculate(pos + 4, input)

      8 ->
        data
        |> equal_op(first_mode, second_mode, pos)
        |> calculate(pos + 4, input)

      _ ->
        data
        |> replace_value(opcode, first_mode, second_mode, pos)
        |> calculate(pos + 4, input)
    end
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
  end

  defp jump_true(data, first_mode, second_mode, pos) do
    first_param = get_num(data, first_mode, pos + 1)

    case first_param do
      0 -> pos + 3
      _ -> get_num(data, second_mode, pos + 2)
    end
  end

  defp jump_false(data, first_mode, second_mode, pos) do
    first_param = get_num(data, first_mode, pos + 1)

    case first_param do
      0 -> get_num(data, second_mode, pos + 2)
      _ -> pos + 3
    end
  end

  def less_than_op(data, first_mode, second_mode, pos) do
    first_param = get_num(data, first_mode, pos + 1)
    second_param = get_num(data, second_mode, pos + 2)

    case first_param < second_param do
      true -> List.replace_at(data, Enum.at(data, pos + 3), 1)
      false -> List.replace_at(data, Enum.at(data, pos + 3), 0)
    end
  end

  def equal_op(data, first_mode, second_mode, pos) do
    first_param = get_num(data, first_mode, pos + 1)
    second_param = get_num(data, second_mode, pos + 2)

    case first_param == second_param do
      true -> List.replace_at(data, Enum.at(data, pos + 3), 1)
      false -> List.replace_at(data, Enum.at(data, pos + 3), 0)
    end
  end

  defp pad_instruction(instruction) do
    case Enum.count(instruction) do
      5 -> instruction
      _ -> pad_instruction([0 | instruction])
    end
  end

  defp set_input(data, pos, input) do
    [val | remaining] = input.input

    replace_pos = Enum.at(data, pos)
    {List.replace_at(data, replace_pos, val), Map.put(input, :input, remaining)}
  end

  defp output_value(data, pos, input) do
    Map.put(input, :output, Enum.at(data, Enum.at(data, pos)))
  end

  defp replace_value(data, action, first_mode, second_mode, pos) do
    new_val =
      calc_value(
        action,
        get_num(data, first_mode, pos + 1),
        get_num(data, second_mode, pos + 2)
      )

    data
    |> List.replace_at(Enum.at(data, pos + 3), new_val)
  end

  defp get_num(data, 0, pos) do
    value_pos = Enum.at(data, pos)
    Enum.at(data, value_pos)
  end

  defp get_num(data, 1, pos) do
    Enum.at(data, pos)
  end

  defp calc_value(1, first, second) do
    first + second
  end

  defp calc_value(2, first, second) do
    first * second
  end
end

D7P1.run!()
|> IO.inspect()
