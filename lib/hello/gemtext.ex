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
    |> tag(ascii_string([?a..?z, 32, ?A..?Z], min: 1), :title)
  end
end

defmodule Hello.Gemtext do
  import NimbleParsec
  import Hello.Gemtext.Helpers

  defparsec(
    :links,
    times(
      link_marker()
      |> filename()
      |> ignore(string(" "))
      |> title()
      |> ignore(string("\n"))
      |> wrap(),
      min: 1
    )
  )

  def table_of_contents(gemtext) do
    {:ok, data, _, _, _, _} = links(gemtext)
    data
  end
end
