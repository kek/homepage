defmodule Hello.Gemtext do
  import NimbleParsec

  defparsec(
    :links,
    times(
      ignore(string("=> "))
      |> ascii_string([?a..?z, ?-], min: 1)
      |> string(".gmi")
      |> wrap()
      |> map({Enum, :join, []})
      |> tag(:file)
      |> ignore(string(" "))
      |> tag(ascii_string([?a..?z, 32, ?A..?Z], min: 1), :title)
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
