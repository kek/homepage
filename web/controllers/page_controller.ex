defmodule Hello.PageController do
  use Hello.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", present: present(), node_infos: node_infos())
  end

  defp present do
    %{}
  end

  defp node_infos do
    []
  end
end
