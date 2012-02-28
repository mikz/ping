class Pong < ActiveRecord::Base
  belongs_to :user
  default_scope :order => "created_at DESC"

  set_table_name "pings"
end
