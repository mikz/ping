desc "import pongs from facebook"
task :facebook_import => :environment do
  while true
    facebook_users = User.where("facebook_user_id is not null AND credentials is not null").each do |fb_user|
      graph = Koala::Facebook::API.new(fb_user.credentials[:token])
      graph.get_connections("me", "home").each do |event|
        if event["from"]["id"]
          u = User.find_by_facebook_user_id(event["from"]["id"].to_s)
          next if u.nil? || Pong.find_by_facebook_id(event["id"].to_s)
          coord = if event["place"] && event["place"]["location"]
            [event["place"]["location"]["latitude"], event["place"]["location"]["longitude"]]
          else
            [nil, nil]
          end
          u.pongs.create :source => 'facebook', :latitude => coord.first, :longitude => coord.last, :facebook_id => event["id"].to_s
        end
      end
    end
    sleep 60
  end
end
