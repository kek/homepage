defmodule Hello.Gemtext do
  import NimbleParsec

  defparsec(
    :table_of_contents,
    times(
      wrap(
        tag(
          ignore(string("=> "))
          |> wrap(
            ascii_string([?a..?z, ?-], min: 1)
            |> string(".gmi")
          )
          |> map({Enum, :join, []}),
          :file
        )
        |> ignore(string(" "))
        |> tag(ascii_string([?a..?z, 32, ?A..?Z], min: 1), :title)
      )
      |> ignore(string("\n")),
      min: 1
    )
  )
end
