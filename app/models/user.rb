class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :rememberable, :trackable, :token_authenticatable

  serialize :credentials

  # Setup accessible (or protected) attributes for your model
  attr_accessible :remember_me

  has_many :pongs

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    info = access_token.info
    data = access_token.extra.raw_info
    if user = User.where(:facebook_user_id => data.id.to_s).first
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

  def import_friends!
  end
end
