class FriendsController < ApplicationController
  respond_to :html
  def index
    @friends = current_user.friends
    respond_with @friends
  end
end
