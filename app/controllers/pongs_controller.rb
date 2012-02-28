class PongsController < ApplicationController
  respond_to :json

  def index
    scope = case params[:scope].try(:to_sym)
    when :friends
      Pong.where(:user_id => current_user.friend_ids)
    else
      Pong.scoped({})
    end

    if last = params[:last_poll].try(:to_time)
      scope = scope.where(["created_at >= ?", last])
    else
      scope = scope.limit(10)
    end

    all = scope.all

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
