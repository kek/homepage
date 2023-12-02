defmodule HelloWeb.ThingController do
  use HelloWeb, :controller

  def index(conn, _params) do
    things = [
      %{title: "Thing 1", description: "yes\n\nno"},
      %{title: "Thing 2", description: "maybe not\n\nor perhaps"}
    ]

    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> json(things)
  end
end
