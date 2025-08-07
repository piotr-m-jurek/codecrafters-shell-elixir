defmodule CLI do
  @available_commands ["echo", "exit", "type"]

  def main(_) do
    # Uncomment this block to pass the first stage
    # System.get_env("PATH") |> String.split(":") |> IO.inspect(label: "ENV: ")

    loop()
  end

  defp loop() do
    msg =
      case IO.gets("$ ") |> String.trim() do
        "type " <> command when command in @available_commands ->
          "#{type(command)}"

        "type " <> command ->
          case System.find_executable(command) do
            nil ->
              "#{command}: not found"

            path ->
              "#{command} is #{String.trim(path)}"
          end

        "echo " <> echo ->
          "#{echo}"

        "exit " <> _code ->
          exit(:normal)

        c ->
          [command | args] = c |> String.split(" ")

          case System.find_executable(command) do
            nil ->
              "#{c}: command not found"

            path ->
              {outcome, _exit_code} =
                System.cmd(path, args, stderr_to_stdout: true, arg0: command)

              String.trim(outcome)
          end
      end

    IO.write("#{msg}\n")
    loop()
  end

  defp type("echo"), do: "echo is a shell builtin"
  defp type("exit"), do: "exit is a shell builtin"
  defp type("type"), do: "type is a shell builtin"
  defp type(c), do: "#{c}: not found"
end
