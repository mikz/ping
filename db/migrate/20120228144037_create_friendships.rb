class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.belongs_to :owner, :null => false
      t.belongs_to :friend, :null => false

      t.timestamps
    end
    add_index :friendships, :owner_id
    add_index :friendships, :friend_id
  end
end
