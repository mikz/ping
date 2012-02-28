class PongsController < ApplicationController

  def index
    render json: Pong.all.to_json
  end

end
