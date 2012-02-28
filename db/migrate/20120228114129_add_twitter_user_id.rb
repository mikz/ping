class AddTwitterUserId < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.column :twitter_user_id, :string
    end
  end
end
