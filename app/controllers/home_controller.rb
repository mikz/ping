class HomeController < ApplicationController
  def index
    @pongs = if current_user
               Pong.where(:user_id => current_user.friend_ids)
             else
               Pong.scoped({}).limit(20)
             end
  end
end
