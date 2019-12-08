defmodule D7P1 do
  def run!() do
    operations =
      File.read!("day-7-input.txt")
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    input_options = permutations([5, 6, 7, 8, 9])

    inputs = %{
      A: 0,
      B: nil,
      C: nil,
      D: nil,
      E: nil
    }

    Enum.map(input_options, fn input ->
      amplifier_state = %{
        A: %{data: operations, next: :B, pos: 0, init: Enum.at(input, 0), final_output: nil},
        B: %{data: operations, next: :C, pos: 0, init: Enum.at(input, 1), final_output: nil},
        C: %{data: operations, next: :D, pos: 0, init: Enum.at(input, 2), final_output: nil},
        D: %{data: operations, next: :E, pos: 0, init: Enum.at(input, 3), final_output: nil},
        E: %{data: operations, next: :A, pos: 0, init: Enum.at(input, 4), final_output: nil}
      }

      calculate(amplifier_state, inputs, :A)
    end)
    |> Enum.max()
  end

  defp calculate(amplifier_state, inputs, amplifier) do
    current_amplifier = Map.get(amplifier_state, amplifier)
    %{pos: pos, data: data, next: next_amplifier} = current_amplifier

    instruction =
      data
      |> Enum.at(pos)
      |> Integer.digits()
      |> pad_instruction()

    [_third_mode, second_mode, first_mode, opcode1, opcode2] = instruction
    opcode = Integer.undigits([opcode1, opcode2])

    case opcode do
      99 ->
        case amplifier do
          :E -> current_amplifier.final_output
          _ -> calculate(amplifier_state, inputs, next_amplifier)
        end

      3 ->
        input =
          case pos do
            0 -> current_amplifier.init
            _ -> Map.get(inputs, amplifier)
          end

        data = set_input(data, pos + 1, input)

        amplifier_state
        |> update_state(amplifier, :data, data)
        |> update_state(amplifier, :pos, pos + 2)
        |> calculate(inputs, amplifier)

      4 ->
        input = output_value(data, pos + 1)

        inputs = Map.put(inputs, next_amplifier, input)

        amplifier_state
        |> update_state(amplifier, :pos, pos + 2)
        |> update_state(amplifier, :final_output, input)
        |> calculate(inputs, next_amplifier)

      5 ->
        new_pos = jump_true(data, first_mode, second_mode, pos)

        amplifier_state
        |> update_state(amplifier, :pos, new_pos)
        |> calculate(inputs, amplifier)

      6 ->
        new_pos = jump_false(data, first_mode, second_mode, pos)

        amplifier_state
        |> update_state(amplifier, :pos, new_pos)
        |> calculate(inputs, amplifier)

      7 ->
        data = less_than_op(data, first_mode, second_mode, pos)

        amplifier_state
        |> update_state(amplifier, :data, data)
        |> update_state(amplifier, :pos, pos + 4)
        |> calculate(inputs, amplifier)

      8 ->
        data = equal_op(data, first_mode, second_mode, pos)

        amplifier_state
        |> update_state(amplifier, :data, data)
        |> update_state(amplifier, :pos, pos + 4)
        |> calculate(inputs, amplifier)

      _ ->
        data = replace_value(data, opcode, first_mode, second_mode, pos)

        amplifier_state
        |> update_state(amplifier, :pos, pos + 4)
        |> update_state(amplifier, :data, data)
        |> calculate(inputs, amplifier)
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
    replace_pos = Enum.at(data, pos)
    List.replace_at(data, replace_pos, input)
  end

  defp output_value(data, pos) do
    Enum.at(data, Enum.at(data, pos))
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

  defp update_state(amplifier_state, amplifier, key, value) do
    Map.put(
      amplifier_state,
      amplifier,
      Map.put(amplifier_state[amplifier], key, value)
    )
  end
end

D7P1.run!()
|> IO.puts()
