desc 'Twitter Stream importer'
task :twitter_stream => :environment do

  TweetStream.configure do |config|
    config.username = TWITTER_USERNAME
    config.password = TWITTER_PASSWORD
    config.auth_method = :basic
    config.parser   = :yajl
  end

  while true
    client = TweetStream::Client.new
    client.on_interval(60) do
      client.stop
      return
    end
    client.follow(User.all.map{|u| u.twitter_user_id}.compact) do |status|
      u = User.find_by_twitter_user_id(status[:user][:id_str])
      next if u.nil?
      puts "Adding twitter pong to user #{u.id}"
      coord = if status[:place] 
        geo_center(status[:place][:bounding_box][:coordinates])
      else
        [nil, nil]
      end
      u.pongs.create(:latitude => coord.first, :longitude => coord.last, :source => 'twitter')
    end
  end
end

def geo_center(coordinates)
  actual_coordinates = coordinates.first
  lat = actual_coordinates.map { |a| a.first }.inject(:+) /4.0
  long = actual_coordinates.map { |a| a.last }.inject(:+) /4.0
  [lat, long]
end
