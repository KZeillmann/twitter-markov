defmodule TwitterMarkov.Web.PageController do
  use TwitterMarkov.Web, :controller

  def result(conn, %{"form_data" => %{"username" => ""}}) do
    render conn, "index.html", error: "Please enter a Twitter handle."
  end

  def result(conn, %{"form_data" => %{"username" => username}}) do
    #TODO: When ExTwitter updates error handling, do this more gracefully
    case TwitterMarkov.Markov.get_sample_tweet(username) do
      {:error, reason} -> render conn, "index.html",error: reason
      {text, user} -> render conn, "result.html", tweet: text, user: user
    end
  end

  def index(conn, _params) do
    render conn, "index.html", error: nil
  end

end
