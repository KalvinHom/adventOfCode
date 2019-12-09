# defmodule Day09 do
#   def part1(input \\ 1) do
#     program = "1102,34915192,34915192,7,4,7,99,0"

#     memory = read_program(program)
#     memory = set_input(memory, [input])
#     memory = execute(memory)
#     read_output(memory)
#   end

#   def part2(program) do
#     memory = read_program(program)
#     memory = set_input(memory, [2])
#     memory = execute(memory)
#     read_output(memory)
#   end

#   defp execute(memory, ip \\ 0) do
#     {opcode, modes} = fetch_opcode(memory, ip)

#     case opcode do
#       1 ->
#         memory = exec_arith_op(&+/2, modes, memory, ip)
#         execute(memory, ip + 4)

#       2 ->
#         memory = exec_arith_op(&*/2, modes, memory, ip)
#         execute(memory, ip + 4)

#       3 ->
#         memory = exec_input(modes, memory, ip)
#         execute(memory, ip + 2)

#       4 ->
#         memory = exec_output(modes, memory, ip)
#         execute(memory, ip + 2)

#       5 ->
#         ip = exec_if(&(&1 !== 0), modes, memory, ip)
#         execute(memory, ip)

#       6 ->
#         ip = exec_if(&(&1 === 0), modes, memory, ip)
#         execute(memory, ip)

#       7 ->
#         memory = exec_cond(&(&1 < &2), modes, memory, ip)
#         execute(memory, ip + 4)

#       8 ->
#         memory = exec_cond(&(&1 === &2), modes, memory, ip)
#         execute(memory, ip + 4)

#       9 ->
#         memory = exec_inc_rel_base(modes, memory, ip)
#         execute(memory, ip + 2)

#       99 ->
#         memory
#     end
#   end

#   defp exec_arith_op(op, modes, memory, ip) do
#     [in1, in2] = read_operand_values(memory, ip + 1, modes, 2)
#     out_addr = read_out_address(memory, div(modes, 100), ip + 3)
#     result = op.(in1, in2)
#     write(memory, out_addr, result)
#   end

#   defp exec_input(modes, memory, ip) do
#     out_addr = read_out_address(memory, modes, ip + 1)
#     input = Map.fetch!(memory, :input)
#     memory = Map.put(memory, :input, tl(input))
#     write(memory, out_addr, hd(input))
#   end

#   defp exec_output(modes, memory, ip) do
#     [value] = read_operand_values(memory, ip + 1, modes, 1)
#     output = Map.get(memory, :output, [])
#     output = [value | output]
#     IO.inspect(output)
#     Map.put(memory, :output, output)
#   end

#   defp exec_if(op, modes, memory, ip) do
#     [value, new_ip] = read_operand_values(memory, ip + 1, modes, 2)

#     case op.(value) do
#       true -> new_ip
#       false -> ip + 3
#     end
#   end

#   defp exec_cond(op, modes, memory, ip) do
#     [operand1, operand2] = read_operand_values(memory, ip + 1, modes, 2)
#     out_addr = read_out_address(memory, div(modes, 100), ip + 3)

#     result =
#       case op.(operand1, operand2) do
#         true -> 1
#         false -> 0
#       end

#     write(memory, out_addr, result)
#   end

#   defp exec_inc_rel_base(modes, memory, ip) do
#     [offset] = read_operand_values(memory, ip + 1, modes, 1)
#     base = get_rel_base(memory) + offset
#     Map.put(memory, :rel_base, base)
#   end

#   defp read_operand_values(_memory, _addr, _modes, 0), do: []

#   defp read_operand_values(memory, addr, modes, n) do
#     operand = read(memory, addr)

#     operand =
#       case rem(modes, 10) do
#         0 -> read(memory, operand)
#         1 -> operand
#         2 -> read(memory, operand + get_rel_base(memory))
#       end

#     [operand | read_operand_values(memory, addr + 1, div(modes, 10), n - 1)]
#   end

#   defp read_out_address(memory, modes, addr) do
#     out_addr = read(memory, addr)

#     case modes do
#       0 -> out_addr
#       2 -> get_rel_base(memory) + out_addr
#     end
#   end

#   defp fetch_opcode(memory, ip) do
#     opcode = read(memory, ip)
#     modes = div(opcode, 100)
#     opcode = rem(opcode, 100)
#     {opcode, modes}
#   end

#   defp get_rel_base(memory) do
#     Map.get(memory, :rel_base, 0)
#   end

#   defp set_input(memory, input) do
#     Map.put(memory, :input, input)
#   end

#   defp read_output(memory), do: Enum.reverse(Map.get(memory, :output, []))

#   defp read(memory, addr) do
#     Map.get(memory, addr, 0)
#   end

#   defp write(memory, addr, value) do
#     Map.put(memory, addr, value)
#   end

#   defp read_program(input) do
#     String.split(input, ",")
#     |> Stream.map(&String.to_integer/1)
#     |> Stream.with_index()
#     |> Stream.map(fn {code, index} -> {index, code} end)
#     |> Map.new()
#   end
# end

# Day09.part1()

defmodule D9P1 do
  def run!() do
    # "104,1125899906842624,99"

    # "109,100,99"
    # "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
    "109,7,21101,34915192,34915192,0,204,2,204,-5,99,0"

    File.read!("day-9-input.txt")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> calculate(0, 0)
  end

  defp calculate(data, pos, relative_pos) do
    instruction =
      data
      |> Enum.at(pos)
      |> Integer.digits()
      |> pad_instruction()

    [third_mode, second_mode, first_mode, opcode1, opcode2] = instruction
    IO.inspect(instruction)
    op = Integer.undigits([opcode1, opcode2])
    opcode(op, data, first_mode, second_mode, third_mode, pos, relative_pos)
  end

  defp opcode(op, data, first_mode, second_mode, third_mode, pos, relative_pos)
       when op == 1 or op == 2 do
    IO.inspect(
      "#{op}: #{Enum.at(data, pos + 1)} #{Enum.at(data, pos + 2)} #{Enum.at(data, pos + 3)}"
    )

    new_val = calc_value(op, data, first_mode, second_mode, pos, relative_pos)
    IO.inspect("set #{get_pos(data, third_mode, pos + 3, relative_pos)} to #{new_val}")

    List.replace_at(data, get_pos(data, third_mode, pos + 3, relative_pos), new_val)
    |> calculate(pos + 4, relative_pos)
  end

  defp opcode(3, data, first_mode, _second_mode, _third_mode, pos, relative_pos) do
    IO.inspect("3: #{Enum.at(data, pos + 1)}")
    input = IO.gets(:stdio, "Enter input") |> String.trim() |> String.to_integer()

    IO.inspect("set #{get_pos(data, first_mode, pos + 1, relative_pos)} to #{input}")

    List.replace_at(data, get_pos(data, first_mode, pos + 1, relative_pos), input)
    |> calculate(pos + 2, relative_pos)
  end

  defp opcode(4, data, first_mode, _, _, pos, relative_pos) do
    IO.inspect("4: getting val at #{pos + 1}, mode #{first_mode} rel #{relative_pos}")
    IO.inspect(data)
    IO.puts(get_num(data, first_mode, pos + 1, relative_pos))

    calculate(data, pos + 2, relative_pos)
  end

  defp opcode(5, data, first_mode, second_mode, _, pos, relative_pos) do
    IO.inspect("5: #{Enum.at(data, pos + 1)} #{Enum.at(data, pos + 2)}")

    param1 = get_num(data, first_mode, pos + 1, relative_pos)
    IO.inspect("#{param1} == 0? to set #{get_num(data, second_mode, pos + 2, relative_pos)}")
    IO.inspect(param1 == 0)

    next_pos =
      case param1 == 0 do
        true -> pos + 3
        _ -> get_num(data, second_mode, pos + 2, relative_pos)
      end

    IO.inspect("next pos: #{next_pos}")
    calculate(data, next_pos, relative_pos)
  end

  defp opcode(6, data, first_mode, second_mode, _, pos, relative_pos) do
    param1 = get_num(data, first_mode, pos + 1, relative_pos)
    IO.inspect("5: #{Enum.at(data, pos + 1)} #{Enum.at(data, pos + 2)}")

    param1 = get_num(data, first_mode, pos + 1, relative_pos)
    IO.inspect("#{param1} == 0? to set #{get_num(data, second_mode, pos + 2, relative_pos)}")
    IO.inspect(param1 == 0)

    next_pos =
      case param1 do
        0 -> get_num(data, second_mode, pos + 2, relative_pos)
        _ -> pos + 3
      end

    calculate(data, next_pos, relative_pos)
  end

  defp opcode(7, data, first_mode, second_mode, third_mode, pos, relative_pos) do
    IO.inspect("7: #{Enum.at(data, pos + 1)} #{Enum.at(data, pos + 2)} #{Enum.at(data, pos + 3)}")

    param1 = get_num(data, first_mode, pos + 1, relative_pos)
    param2 = get_num(data, second_mode, pos + 2, relative_pos)
    replace_pos = get_pos(data, third_mode, pos + 3, relative_pos)
    IO.inspect("#{param1} < #{param2}?")

    new_val =
      case param1 < param2 do
        true -> 1
        false -> 0
      end

    IO.inspect("set #{replace_pos} to #{new_val}")

    List.replace_at(data, replace_pos, new_val)
    |> calculate(pos + 4, relative_pos)
  end

  defp opcode(8, data, first_mode, second_mode, third_mode, pos, relative_pos) do
    param1 = get_num(data, first_mode, pos + 1, relative_pos)
    param2 = get_num(data, second_mode, pos + 2, relative_pos)
    replace_pos = get_pos(data, third_mode, pos + 3, relative_pos)

    new_val =
      case param1 == param2 do
        true -> 1
        false -> 0
      end

    List.replace_at(data, replace_pos, new_val)
    |> calculate(pos + 4, relative_pos)
  end

  defp opcode(9, data, first_mode, _, _, pos, relative_pos) do
    IO.inspect("9: #{pos} #{Enum.at(data, pos + 1)}")

    param = relative_pos + get_num(data, first_mode, pos + 1, relative_pos)

    IO.inspect(
      "set relative to #{get_num(data, first_mode, pos + 1, relative_pos)} + #{relative_pos}"
    )

    calculate(data, pos + 2, param)
  end

  defp opcode(99, data, _, _, _, _, _) do
    data
  end

  defp calc_value(1, data, first_mode, second_mode, pos, relative_pos) do
    get_num(data, first_mode, pos + 1, relative_pos) +
      get_num(data, second_mode, pos + 2, relative_pos)
  end

  defp calc_value(2, data, first_mode, second_mode, pos, relative_pos) do
    get_num(data, first_mode, pos + 1, relative_pos) *
      get_num(data, second_mode, pos + 2, relative_pos)
  end

  defp get_pos(data, mode, pos, relative_pos)

  defp get_pos(data, 0, pos, _) do
    Enum.at(data, pos) || 0
  end

  defp get_pos(data, 2, pos, relative_pos), do: (Enum.at(data, pos) || 0) + relative_pos

  defp get_num(data, 1, pos, _) do
    Enum.at(data, pos) || 0
  end

  defp get_num(data, mode, pos, relative_pos) do
    Enum.at(data, get_pos(data, mode, pos, relative_pos)) || 0
  end

  defp pad_instruction(instruction) do
    case Enum.count(instruction) do
      5 -> instruction
      _ -> pad_instruction([0 | instruction])
    end
  end
end

D9P1.run!()
