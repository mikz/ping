class AddPingsTable < ActiveRecord::Migration
  def change
    create_table :pings do |t|
      t.integer :user_id
      t.string :latitude
      t.string :longitude
      t.string :source
      t.timestamps
    end

    add_index :pings, :user_id
  end
end
