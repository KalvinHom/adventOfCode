defmodule D1P2 do
  def run!() do
    File.read!("day-1-input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&calculate(String.to_integer(&1)))
    |> Enum.sum()
  end

  defp calculate(mass) do
    mass
    |> div(3)
    |> Kernel.-(2)
    |> case do
      f when f <= 0 -> 0
      f -> f + calculate(f)
    end
  end
end

D1P2.run!()
|> IO.puts()
