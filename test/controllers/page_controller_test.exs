defmodule Hello.PageControllerTest do
  use Hello.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "DOCTYPE html"
  end
end
