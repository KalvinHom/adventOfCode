defmodule D8P1 do
  def run! do
    size = 25 * 6

    pixels =
      File.read!("day-8-input.txt")
      |> String.codepoints()
      |> Enum.chunk_every(size)
      |> Enum.min_by(fn pixels -> Enum.count(pixels, &(&1 == "0")) end)

    Enum.count(pixels, &(&1 == "1")) * Enum.count(pixels, &(&1 == "2"))
  end
end

D8P1.run!()
|> IO.puts()
