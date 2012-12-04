# We will call this code like this:

require_relative '../config/api_keys_config.rb'
# require 'youtube_it'
# require 'rest_client'
# require 'json'


FACEBOOK_KEY = '482081311836995'
FACEBOOK_SECRET = 'db541a0ee6682b9802cb44523c56babf'
TINYSONG_API_KEY = "0af53736101aebb91f579527433c9208"
ECHONEST_API_KEY = "UQMLHGHVTVSWYKWEW"
YOUTUBE_API_KEY = "AI39si6i1YvfcT64qFK06lhB9oT_4NuGkRnSHmyrH7XmFkOx6jtLimBtDl-NOX7-RSqqcBKH-RpuJHae3Xo6ulUT8paIk9Nh1w"

module TinySonger
  def self.search(query)
    all_songs(search_results(query))
  end

  def self.search_results(query)
    query = CGI::escape(query)
    key = ECHONEST_API_KEY
    JSON.parse(RestClient.get"http://developer.echonest.com/api/v4/song/search?api_key=#{key}&artist=#{query}")
  end

  def self.all_songs(songs_data)
    songs_data["response"]["songs"].collect { |song| Result.new(song) }
  end
end

class Result
  def initialize(hash_data)
    @hash_data = hash_data
  end

  def tiny_id
    @hash_data["id"]
  end

  def title
    @hash_data["title"]
  end

  def artist
    @hash_data["artist_name"]
  end

  def youtube_id
    self.class.get_youtube_id(artist, title)
  end

  def self.get_youtube_id(artist, title)
    video_data = youtube_client.videos_by(:query => ("#{artist} #{title}"), :categories => [:music])
    video_data.videos.first.video_id.split(':').last
  end

  def youtube_client
    self.class.youtube_client
  end

  def self.youtube_client
    @youtube_client ||= YouTubeIt::Client.new(:dev_key => YOUTUBE_API_KEY)
  end
end
# puts TinySonger.all_songs(TinySonger.search_results("love"))[2].tiny_id