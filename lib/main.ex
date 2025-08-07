defmodule CLI do
  def main(_args) do
    # Uncomment this block to pass the first stage
    loop()
  end

  defp loop() do
    case IO.gets("$ ") |> String.replace("\n", "") do
      c -> IO.write("#{c}: command not found\n")
    end

    loop()
  end
end
