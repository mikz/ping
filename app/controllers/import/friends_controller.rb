class Import::FriendsController < ApplicationController
  before_filter :require_login

  respond_to :xml, :json

  def create
    @friends = current_user.import_friends!

    redirect_to :back
  end

end
