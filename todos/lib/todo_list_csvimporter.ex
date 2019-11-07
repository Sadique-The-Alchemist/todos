defmodule TodoList.CsvImporter do
  @moduledoc """
  Read lines from a file and create a todolist 
  """
  @doc """
  Stream a file from a specific path and formated to a list of map and applied to Todolist.new/1 it will expect a path to a file 
  contains data
  """
  def import(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ","))
    |> Enum.map(fn [k, v] -> {k, v} end)
    |> Enum.map(fn {k, v} -> {String.split(k, "/"), v} end)
    |> Enum.map(fn {[year, month, date], title} ->
      {Date.from_erl(
         {String.to_integer(year), String.to_integer(month), String.to_integer(date)}
       ), title}
    end)
    |> Enum.map(fn {{:ok, k}, v} -> {k, v} end)
    |> Enum.map(fn {k, v} -> %{date: k, title: v} end)
    |> TodoList.new()
  end
end
