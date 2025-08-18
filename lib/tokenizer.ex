defmodule Tokenizer do
  @type state :: :single_quote | :no_quote | :double_quote

  @spec tokenize(binary(), list(binary()), binary(), state()) :: list(binary())
  def tokenize(<<>>, tokens, current, _) do
    Enum.reverse([current | tokens]) |> Enum.reject(&(&1 == ""))
  end

  def tokenize(<<"\\", char, rest::binary>>, tokens, current, :no_quote) do
    tokenize(rest, tokens, current <> <<char>>, :no_quote)
  end

  def tokenize(<<"\\", char, rest::binary>>, tokens, current, :double_quote)
      when char in [?\\, ?\"] do
    tokenize(rest, tokens, current <> <<char>>, :double_quote)
  end

  def tokenize(<<"\\", char, rest::binary>>, tokens, current, :single_quote)
      when char in [?\\, ?\'] do
    tokenize(rest, tokens, current <> <<char>>, :single_quote)
  end

  def tokenize(<<"'", rest::binary>>, tokens, current, :no_quote) do
    tokenize(rest, tokens, current, :single_quote)
  end

  def tokenize(<<"'", rest::binary>>, tokens, current, :single_quote) do
    tokenize(rest, tokens, current, :no_quote)
  end

  def tokenize(<<"\"", rest::binary>>, tokens, current, :no_quote) do
    tokenize(rest, tokens, current, :double_quote)
  end

  def tokenize(<<"\"", rest::binary>>, tokens, current, :double_quote) do
    tokenize(rest, tokens, current, :no_quote)
  end

  def tokenize(<<" ", rest::binary>>, tokens, current, :no_quote) do
    tokenize(rest, [current | tokens], "", :no_quote)
  end

  def tokenize(<<ch, rest::binary>>, tokens, current, state) do
    tokenize(rest, tokens, current <> <<ch>>, state)
  end
end
