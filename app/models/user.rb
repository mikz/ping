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

  def import_from_twitter!
    Twitter.configure do |config|
      config.consumer_key = TWITTER_TOKEN
      config.consumer_secret = TWITTER_SECRET
      config.oauth_token = self.credentials[:token]
      config.oauth_token_secret = self.credentials[:secret]
    end

    client = Twitter::Client.new
    all_friends = get_twitter_friends_with_cursor(-1,[],client)
    get_twitter_users(all_friends,client).map do |friend|
      user = User.where(:twitter_user_id => friend['id'].to_s).first
      unless user
        user = User.create! { |user|
          user.twitter_user_id = friend['id'].to_s
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
      user.name = info.name
      user.save!
      user
    else # Create a user with a stub password.
      User.create!{ |user|
        user.facebook_user_id = data.id.to_s
        user.image_url = info.image
        user.credentials = access_token.credentials
        user.name = info.name
      }
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    info = access_token.info
    data = access_token.extra.raw_info
    if user = User.where(:twitter_user_id => data.id.to_s).first
      user.credentials = access_token.credentials
      user.name = info.name
      user.save!
      user
    else # Create a user with a stub password.
      User.create! { |user|
        user.twitter_user_id = data.id.to_s
        user.image_url = info.image
        user.credentials = access_token.credentials
        user.name = info.name
      }
    end
  end

  private

  def get_twitter_friends_with_cursor(cursor, list, client)
    # Base case
    if cursor == 0
      return list
    else
      hashie = client.friend_ids(:cursor => cursor)
      hashie.ids.each {|u| list << u } # Concat users to list
      get_twitter_friends_with_cursor(hashie.next_cursor,list,client) # Recursive step using the next cursor
    end
  end

  def get_twitter_users(user_ids, client)
    users = []
    user_ids.in_groups_of(100).each do |group|
      users.concat(client.friendships(group))
    end
    users
  end
end
