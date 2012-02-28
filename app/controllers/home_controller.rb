class HomeController < ApplicationController
  def index
    if current_user
      @pongs = Pong.where(:user_id => current_user.friend_ids)
    else
      Pong.scoped({}).limit(20)
    end
  end
end
