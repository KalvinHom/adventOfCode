defmodule D4P2 do
  def run!() do
    Enum.reduce(138_307..654_504, 0, fn number, count ->
      valid = never_decrease?(number) && has_repeat?(number)

      case valid do
        true -> count + 1
        false -> count
      end
    end)
  end

  defp never_decrease?(number) do
    number
    |> Integer.digits()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [x, y] -> x <= y end)
  end

  defp has_repeat?(number) do
    digits =
      number
      |> Integer.digits()

    [0 | digits]
    |> Enum.chunk_every(4, 1)
    |> Enum.any?(fn [w, x, y | z] ->
      w != x && x == y and [y] != z
    end)
  end
end

D4P2.run!()
|> IO.puts()
