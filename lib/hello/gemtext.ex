defmodule Hello.Gemtext.Helpers do
  import NimbleParsec

  def link_marker(combinator \\ empty()) do
    combinator
    |> string("=> ")
    |> ignore()
  end

  def filename(combinator \\ empty()) do
    combinator
    |> ascii_string([?a..?z, ?-], min: 1)
    |> string(".gmi")
    |> wrap()
    |> map({Enum, :join, []})
    |> tag(:file)
  end

  def title(combinator \\ empty()) do
    combinator
    |> tag(text(), :title)
  end

  def text(combinator \\ empty()) do
    ascii_string(combinator, [32..127], min: 1)
  end

  def link do
    link_marker()
    |> filename()
    |> ignore(string(" "))
    |> title()
    |> ignore(string("\n"))
    |> wrap()
  end

  def paragraph do
    text()
    |> ignore()
    |> string("\n")
    |> ignore()
  end

  def blank_line do
    string("\n")
    |> ignore()
  end
end

defmodule Hello.Gemtext do
  import NimbleParsec
  import Hello.Gemtext.Helpers
  require Logger

  defparsec(
    :parse,
    times(
      choice([
        link(),
        paragraph(),
        blank_line()
      ]),
      min: 1
    ),
    export_metadata: true
  )

  def table_of_contents(gemtext) do
    case parse(gemtext) do
      {:ok, data, _, _, _, _} ->
        data

      {:error, message, _, _, _, _} ->
        Logger.error(message)
        {:error, message}
    end
  end
end
