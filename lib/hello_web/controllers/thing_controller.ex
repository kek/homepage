defmodule HelloWeb.ThingController do
  use HelloWeb, :controller
  require Logger

  def index(conn, _params) do
    content_directories = [
      "/Users/ke/Documents/gemini/content",
      "/mnt/c/Users/karle/Documents/gemini/content",
      "/home/ke/gemini/content"
    ]

    content_directory = Enum.find(content_directories, &File.exists?/1)

    things =
      if content_directory do
        index = File.read!("#{content_directory}/index.gmi") |> Hello.Gemtext.table_of_contents()
        Logger.debug(inspect(index))

        index
        |> Enum.map(fn [file: [file], title: [title]] ->
          file_path = Path.join(content_directory, file)
          file_contents = File.read!(file_path)
          %{title: title, description: file_contents}
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
