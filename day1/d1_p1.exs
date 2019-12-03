defmodule D1P1 do
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
  end
end

D1P1.run!()
|> IO.puts()
