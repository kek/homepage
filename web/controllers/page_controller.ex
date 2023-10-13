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
    Enum.zip(names(), pings())
    |> Map.new()
  end

  defp node_infos do
    nodes()
    |> Enum.map(fn node ->
      {node, Hello.NodeInfo.info(node)}
    end)
  end
end
