defmodule TwitterMarkov.Web.PageController do
  use TwitterMarkov.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
