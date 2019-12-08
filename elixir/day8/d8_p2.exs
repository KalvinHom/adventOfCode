defmodule D8P2 do
  def run! do
    width = 25
    height = 6
    size = width * height

    layers =
      File.read!("day-8-input.txt")
      |> String.codepoints()
      |> Enum.chunk_every(size)
      |> IO.inspect()

    colors =
      Enum.map(0..(size - 1), fn elem ->
        Enum.reduce_while(layers, 2, fn layer, acc ->
          case Enum.at(layer, elem) do
            "2" -> {:cont, "2"}
            x -> {:halt, x}
          end
        end)
      end)
      |> IO.inspect()

    Enum.map(0..(height - 1), fn y ->
      Enum.map(0..(width - 1), fn x ->
        case Enum.at(colors, width * y + x) do
          "2" -> IO.write(IO.ANSI.black_baground() <> " ")
          "0" -> IO.write(IO.ANSI.white_background() <> "0")
          "1" -> IO.write(IO.ANSI.blue_background() <> "1")
        end
      end)

      IO.write(IO.ANSI.black_background() <> "\n")
    end)
  end
end

D8P2.run!()
