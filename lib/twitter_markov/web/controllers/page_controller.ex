defmodule TwitterMarkov.Web.PageController do
  use TwitterMarkov.Web, :controller

  def result(conn, %{"form_data" => %{"username" => username}}) do
    #TODO: When ExTwitter updates error handling, do this more gracefully
    text =
      try do
        TwitterMarkov.Markov.get_sample_tweet(username)
      rescue
        e in ExTwitter.Error -> e.message
        e -> e.message
      end
    render conn, "result.html", tweet: text, username: username
  end

  def index(conn, _params) do

    render conn, "index.html"
  end

end
