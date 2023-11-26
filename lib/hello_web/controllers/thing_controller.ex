defmodule HelloWeb.ThingController do
  use HelloWeb, :controller

  def index(conn, _params) do
    things = [%{title: "Thing 1"}, %{title: "Thing 2"}]
    json(conn, things)
  end
end
