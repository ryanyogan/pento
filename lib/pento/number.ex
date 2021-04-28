defmodule Number do
  def new(string), do: Integer.parse(string) |> elem(0)
  def add(number, addend), do: number + addend
  def to_string(number), do: Integer.to_string(number)
end
