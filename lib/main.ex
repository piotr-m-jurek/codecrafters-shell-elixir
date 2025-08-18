defmodule CLI do
  @available_commands ["echo", "exit", "type", "pwd", "cwd"]

  def main(_) do
    loop()
  end

  def loop() do
    case IO.gets("$ ") |> String.trim() |> cmd() do
      nil ->
        loop()

      msg ->
        IO.write("#{msg}\n")
        loop()
    end
  end

  @spec cmd(raw_command :: String.t()) :: String.t() | nil | no_return()
  def cmd("echo " <> echo),
    do: echo |> Tokenizer.tokenize([], "", :no_quote) |> Enum.join(" ")

  def cmd("exit 0"), do: exit(:normal)

  def cmd("pwd"), do: File.cwd!()

  def cmd("cd ~") do
    home = System.get_env("HOME")
    cmd("cd #{home}")
  end

  def cmd("cd " <> dir) do
    case File.cd(dir) do
      :ok -> nil
      {:error, _} -> "cd: #{dir}: No such file or directory"
    end
  end

  def cmd("type " <> command) when command in @available_commands,
    do: "#{command} is a shell builtin"

  def cmd("type " <> command) do
    case System.find_executable(command) do
      nil ->
        "#{command}: not found"

      path ->
        "#{command} is #{String.trim(path)}"
    end
  end

  def cmd(command) do
    [command | args] = Tokenizer.tokenize(command, [], "", :no_quote)

    case System.find_executable(command) do
      nil ->
        "#{command}: command not found"

      path ->
        {outcome, _exit_code} =
          System.cmd(path, args, stderr_to_stdout: true, arg0: command)

        String.trim(outcome)
    end
  end
end
