class AddFacebookUserId < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.column :facebook_user_id, :string
    end
  end
end
