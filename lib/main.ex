defmodule CLI do
  def main(_args) do
    # Uncomment this block to pass the first stage
    loop()
  end

  defp loop() do
    case IO.gets("$ ") |> String.trim() do
      "type " <> command ->
        "#{type(command)}\n" |> IO.write()

      "echo " <> echo ->
        IO.write("#{echo}\n")

      "exit " <> _code ->
        exit(:normal)

      c ->
        IO.write("#{c}: command not found\n")
    end

    loop()
  end

  defp type("echo"), do: "echo is a shell builtin"
  defp type("exit"), do: "exit is a shell builtin"
  defp type("type"), do: "type is a shell builtin"
  defp type(c), do: "#{c}: not found"
end
