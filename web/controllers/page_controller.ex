defmodule Hello.PageController do
  use Hello.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", present: present(), node_infos: node_infos())
  end

  # defp names, do: [:harry, :ingrid, :pablo]
  defp names, do: [:pablo]

  defp nodes, do: Enum.map(names(), &:"hello@#{&1}.local")

  defp pings, do: Enum.map(nodes(), &Node.ping/1)

  defp present do
    %{}
  end

  defp node_infos do
    []
  end
end
