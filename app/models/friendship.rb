class Friendship < ActiveRecord::Base
  belongs_to :owner, :class_name => :User
  belongs_to :friend, :class_name => :User

  validates_uniqueness_of :friend_id, :scope => :owner_id
end
