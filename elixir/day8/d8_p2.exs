defmodule D8P2 do
  def run! do
    width = 25
    height = 6
    size = width * height

    layers =
      File.read!("day-8-input.txt")
      |> String.codepoints()
      |> Enum.chunk_every(size)

    colors =
      Enum.map(0..(size - 1), fn elem ->
        Enum.reduce_while(layers, 2, fn layer, acc ->
          case Enum.at(layer, elem) do
            "2" -> {:cont, "2"}
            x -> {:halt, x}
          end
        end)
      end)

    # was curious how much converting to map saves in performance
    # from not iterating list over and over.
    # conclusion: not much with this small dataset, 4ms ish.
    # color_map =
    #   colors
    #   |> Enum.with_index()
    #   |> Enum.map(fn {k, v} -> {v, k} end)
    #   |> Map.new()

    Enum.map(0..(height - 1), fn y ->
      Enum.map(0..(width - 1), fn x ->
        # case Map.get(color_map, width * y + x) do
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

Benchee.run(%{
  "d8 p2" => fn ->
    D8P2.run!()
  end
})
