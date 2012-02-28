class HomeController < ApplicationController
  def index
    @pongs =  [ { name: 'Someone', created_at: 'Today' }, { name: 'You', created_at: 'Yesterday' } ]
#    @pongs = Pong.all
  end
end
