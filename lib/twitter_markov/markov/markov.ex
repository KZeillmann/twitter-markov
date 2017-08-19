defmodule TwitterMarkov.Markov do
  @prefix_length 1

  def get_sample_tweet(username) do
    try do
      create_sample_tweet(username)
    rescue
      e in ExTwitter.Error -> {:error, e.message}
      e -> {:error, e.message}
    end
  end


  def create_sample_tweet(username) do
    tweets = retrieve_past_tweets(username, 200)
    generated_tweet = tweets
        |> Enum.map(&(Map.get(&1, :full_text)))
        |> analyze_tweets
        |> generate_tweet("")
    user = tweets
    |> List.first
    |> Map.get(:user)

    {generated_tweet, user}
  end

  def retrieve_past_tweets(username, count) do
    TwitterMarkov.TwitterHelper.get_tweets(username, count)
  end

  def analyze_tweets(tweets) do
    tweets
    |> Enum.map(&(sanitize_tweet(&1)))
    |> Enum.map(&(analyze_tweet(&1)))
    |> Enum.reduce([], &(&1 ++ &2))
  end

  def sanitize_tweet(tweet) do
    tweet
    |> String.replace(~r(&amp;), "&")
    |> String.replace(~r(&gt;), ">")
    |> String.replace(~r(&tt;), "<")
    |> String.replace(~r(&gt;), ">")
    |> String.replace(~r(https://t.co.*), "");
  end

  def analyze_tweet(tweet) do
    tokens = String.split(tweet) ++ ["\n"]
    last_index = Enum.count(tokens)-1 #subtract one for zero-based indexing
    0..last_index
    |> Enum.map(&(find_slices(tokens, &1)))
    |> Enum.reverse()
    |> Enum.map(&(find_prefix(&1)))
  end

  def find_slices(tokens, index) do
    Enum.slice(Enum.reverse(tokens), index, @prefix_length + 1)
    |> Enum.reverse
  end

  def find_prefix(slice) do
    word = List.last(slice)
    prefix = Enum.join(Enum.drop(slice, -1), " ")
    { prefix, word }
  end

  def generate_tweet(markov_data, chain) do
    next_word = find_next_word(get_prefix(chain), markov_data)
    if next_word == "\n" do
      chain
    else
      generate_tweet(markov_data, add_word_to_chain(chain, next_word))
    end
  end

  def get_prefix(chain) do
    chain
    |> String.split(" ")
    |> Enum.reverse()
    |> Enum.take(@prefix_length)
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  def add_word_to_chain(chain, word) do
    chain
    |> String.split(" ")
    |> Kernel.++([word])
    |> Enum.join(" ")
    |> String.trim()
  end

  def find_next_word(prefix, markov_data) do
    markov_data
    |> Enum.filter(&(prefix == elem(&1, 0)))
    |> Enum.random()
    |> elem(1)
  end
end
