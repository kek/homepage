defmodule HelloWeb.ThingController do
  use HelloWeb, :controller

  def index(conn, _params) do
    content_directories = [
      "/Users/ke/Documents/gemini/content",
      "/mnt/c/Users/karle/Documents/gemini/content",
      "/home/ke/gemini/content"
    ]

    content_directory = Enum.find(content_directories, &File.exists?/1)

    things =
      if content_directory do
        File.ls!(content_directory)
        |> Enum.reject(&(&1 == "index.gmi"))
        |> Enum.map(fn file ->
          file_path = Path.join(content_directory, file)
          file_contents = File.read!(file_path)
          %{title: file, description: file_contents}
        end)
      else
        [
          %{title: "A wonderful headline", description: "yes\n\nno"},
          %{title: "The best section title ever", description: "maybe not\n\nor perhaps"}
        ]
      end

    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> json(things)
  end
end
