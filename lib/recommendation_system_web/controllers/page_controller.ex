defmodule RecommendationSystemWeb.PageController do
  use RecommendationSystemWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
