class PongsController < ApplicationController

  def index
    render json: Pong.all.to_json
  end

  def create
    @pong = current_user.pongs.create 
  end	
end
