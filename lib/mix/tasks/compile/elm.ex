defmodule Mix.Tasks.Compile.Elm do
  use Mix.Task

  def run(_) do
    if {"armv7l\n", 0} == System.cmd("uname", ["-m"]) do
      IO.puts("Skipping Elm compilation on ARM 32")
    else
      with {_output, 0} <-
             System.cmd("elm", [
               "make",
               "src/Main.elm",
               "--optimize",
               "--output=assets/elm/main.js"
             ]) do
        :ok
      else
        {output, status} ->
          {:error, [message: "Elm compilation failed", status: status, output: output]}
      end
    end
  end
end
