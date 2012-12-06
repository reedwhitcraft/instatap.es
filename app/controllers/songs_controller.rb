class SongsController < ApplicationController
  def show
    @artist = params[:artist]
    @title = params[:title]

    respond_to do |format|
      format.js
    end
  end

  def create
    @song = Song.where(params[:song]).first_or_create
    @song.update_attributes(:youtube_id => Result.get_youtube_id(@song.artist, @song.title))
    respond_to do |format|
      format.js
    end
  end
end
