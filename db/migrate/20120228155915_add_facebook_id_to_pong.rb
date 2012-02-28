class AddFacebookIdToPong < ActiveRecord::Migration
  def change
    add_column :pings, :facebook_id, :string
    add_index :pings, :facebook_id
  end
end
