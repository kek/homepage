defmodule Hello.PageController do
  use Hello.Web, :controller

  def index(conn, _params) do
    nodes = [:harry, :ingrid]
    pings = nodes
    |> Enum.map(&(:"hello@#{&1}.local"))
    |> IO.inspect
    |> Enum.map(&Node.ping/1)

    present = Enum.zip(nodes, pings)
    |> Map.new

    render conn, "index.html", present: present
  end
end
