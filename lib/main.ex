defmodule CLI do
  def main(_args) do
    # Uncomment this block to pass the first stage
    command = IO.gets("$ ") |> String.replace("\n", "")

    case command do
      c -> IO.write("#{c}: command not found\n")
    end
  end
end
