defmodule HelloWeb.ThingController do
  use HelloWeb, :controller

  def index(conn, _params) do
    things = [
      %{title: "Thing 1", description: "yes"},
      %{title: "Thing 2", description: "maybe not"}
    ]

    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> json(things)
  end
end
