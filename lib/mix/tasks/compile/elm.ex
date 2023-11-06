defmodule Mix.Tasks.Compile.Elm do
  use Mix.Task

  def run(_) do
    with {_output, 0} <-
           System.cmd("elm", ["make", "src/Main.elm", "--optimize", "--output=assets/elm/main.js"]) do
      :ok
    else
      {output, status} ->
        {:error, [message: "Elm compilation failed", status: status, output: output]}
    end
  end
end
