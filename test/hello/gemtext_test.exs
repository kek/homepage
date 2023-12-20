defmodule Hello.GemtextTest do
  use ExUnit.Case
  import Hello.Gemtext

  test "Parse index.gmi" do
    input = """
    => some-file.gmi Not this one
    => another-document.gmi But this one
    """

    assert table_of_contents(input) == [
             [file: ["some-file.gmi"], title: ["Not this one"]],
             [file: ["another-document.gmi"], title: ["But this one"]]
           ]
  end
end
