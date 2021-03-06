class PongsController < ApplicationController
  respond_to :json

  def index
    scope = case params[:scope].presence.try(:to_sym)
    when :friends
      Pong.where(:user_id => current_user.friend_ids)
    else
      Pong.scoped({})
    end

    begin
      if last = params[:last_poll].presence.try(:to_time)
        scope = scope.where(["created_at >= ?", last])
      else
        scope = scope.limit(10)
      end

    rescue ArgumentError
      scope = scope.limit(10)
    end

    all = scope.all.as_json(:include => {:user => {:only => [:name, :image_url]}})

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
