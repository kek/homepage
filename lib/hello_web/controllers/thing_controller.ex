defmodule HelloWeb.ThingController do
  use HelloWeb, :controller

  def index(conn, _params) do
    content_directory = "/Users/ke/Documents/gemini/content"

    things =
      if File.exists?(content_directory) do
        File.ls!(content_directory)
        |> Enum.map(fn file ->
          file_path = Path.join(content_directory, file)
          file_contents = File.read!(file_path)
          %{title: file, description: file_contents}
        end)
      else
        [
          %{title: "Thing 1", description: "yes\n\nno"},
          %{title: "Thing 2", description: "maybe not\n\nor perhaps"}
        ]
      end

    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> json(things)
  end
end
