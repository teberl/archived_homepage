defmodule PhxClientWeb.PageControllerTest do
  use PhxClientWeb.ConnCase

  test "GET /", %{conn: _conn} do
    conn = get(build_conn(), :index)

    assert conn.status == 200
    assert String.contains?(conn.resp_body, "<title>TEberl · Sofware Developer</title>")
  end
end
