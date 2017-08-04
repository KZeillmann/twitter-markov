defmodule TwitterMarkov.Web.PageView do
  use TwitterMarkov.Web, :view

  def test() do
    TwitterMarkov.Markov.get_sample_tweet("realDonaldTrump")
  end
end
