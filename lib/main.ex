defmodule CLI do
  @available_commands ["echo", "exit", "type", "pwd", "cwd"]

  def main(_) do
    # Uncomment this block to pass the first stage
    # System.get_env("PATH") |> String.split(":") |> IO.inspect(label: "ENV: ")

    loop()
  end

  defp loop() do
    case IO.gets("$ ") |> String.trim() |> handle() do
      nil ->
        loop()

      msg ->
        IO.write("#{msg}\n")
        loop()
    end
  end

  @spec handle(String.t()) :: String.t() | nil | no_return()
  def handle("echo " <> echo), do: "#{echo}"
  def handle("exit 0"), do: exit(:normal)
  def handle("type " <> command) when command in @available_commands, do: "#{type(command)}"
  def handle("pwd"), do: File.cwd!()

  def handle("cd " <> dir) do
    case File.cd(dir) do
      :ok -> nil
      {:error, _} -> "cd: #{dir}: No such file or directory"
    end
  end

  def handle("type " <> command) do
    case System.find_executable(command) do
      nil ->
        "#{command}: not found"

      path ->
        "#{command} is #{String.trim(path)}"
    end
  end

  def handle(c) do
    [command | args] = c |> String.trim() |> String.split(" ") |> Enum.map(&String.trim(&1))

    case System.find_executable(command) do
      nil ->
        "#{c}: command not found"

      path ->
        {outcome, _exit_code} =
          System.cmd(path, args, stderr_to_stdout: true, arg0: command)

        String.trim(outcome)
    end
  end

  defp type("echo"), do: "echo is a shell builtin"
  defp type("exit"), do: "exit is a shell builtin"
  defp type("type"), do: "type is a shell builtin"
  defp type("pwd"), do: "pwd is a shell builtin"
  defp type("cwd"), do: "cwd is a shell builtin"
  defp type(c), do: "#{c}: not found"
end
