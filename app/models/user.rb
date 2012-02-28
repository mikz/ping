class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :rememberable, :trackable, :token_authenticatable

  serialize :credentials

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :remember_me

  has_many :pongs

  has_many :friendships, :foreign_key => :owner_id
  has_many :friends, :through => :friendships

  def make_friend(friend)
    friendships.create :owner => self, :friend => friend
    friendships.create :owner => friend, :friend => self
  end

  def import_friends!
    case
    when facebook?
      import_from_facebook!
    when twitter?
      import_from_twitter!
    end
  end

  def import_from_facebook!
    api = Koala::Facebook::API.new(credentials['token'])
    api.get_connections("me", "friends").map do |friend|
      user = User.where(:facebook_user_id => friend['id']).first
      unless user
        user = User.create! { |user|
          user.facebook_user_id = friend['id']
          user.name = friend['name']
        }
      end
      make_friend(user)
      user
    end
  end

  def facebook?
    facebook_user_id?
  end

  def twitter?
    twitter_user_id?
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    info = access_token.info
    data = access_token.extra.raw_info
    if user = User.where(:facebook_user_id => data.id.to_s).first
      user.credentials = access_token.credentials
      user.save!
      user
    else # Create a user with a stub password.
      User.create!{ |user|
        user.facebook_user_id = data.id.to_s
        user.image_url = info.image
        user.credentials = access_token.credentials
      }
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    info = access_token.info
    data = access_token.extra.raw_info
    if user = User.where(:twitter_user_id => data.id.to_s).first
      user.credentials = access_token.credentials
      user.save!
      user
    else # Create a user with a stub password.
      User.create! { |user|
        user.twitter_user_id = data.id.to_s
        user.image_url = info.image
        user.credentials = access_token.credentials
      }
    end
  end
end
