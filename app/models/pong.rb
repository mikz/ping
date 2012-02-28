class Pong < ActiveRecord::Base
  belongs_to :user

  set_table_name "pings"
end
