defmodule Hello.PageController do
  use Hello.Web, :controller

  def index(conn, _params) do
    names = [:harry, :ingrid]

    pings = names
    |> Enum.map(&(:"hello@#{&1}.local"))
    |> Enum.map(&Node.ping/1)

    present = Enum.zip(names, pings)
    |> Map.new

    render conn, "index.html", present: present
  end
end
