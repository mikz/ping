class PongsController < ApplicationController
  respond_to :json

  def index
    @pongs = Pong.limit(100)

    respond_with(@pongs)
  end

  def create
    attrs = {}
    if coords = params[:coords]
      attrs.merge! coords.slice(:latitude, :longitude)
    end
    @pong = current_user.pongs.create attrs

    respond_with(@pong)
  end	
end
