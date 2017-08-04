defmodule TwitterMarkov.TwitterHelper  do
  def get_tweets(username, count) do
    ExTwitter.user_timeline([screen_name: username, count: count, exclude_replies: true, include_rts: false, tweet_mode: :extended])
  end
end
