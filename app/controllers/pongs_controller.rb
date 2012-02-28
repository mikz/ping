class PongsController < ApplicationController
  respond_to :json

  def index
    # Pong.limit(100)
    all = [ { name: 'Me' }, { name: 'You' } ]

    render json: { last_poll: Time.now, pongs: all }
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
